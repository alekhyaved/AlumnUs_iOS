//
//  ChatLogController.swift
//  AlumnUs
//
//  Created by Leela Alekhya Vedula on 4/14/20.
//  Copyright © 2020 Alekhya. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var contact: Profile? {
        didSet{
            navigationItem.title = contact?.username
            
            observeUserMessages()
        
        }
    }
   lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
    textField.delegate = self
        return textField
    }()
    
    let cellId = "cellId"
    
       var messages = [Message]()
        var messageDictionary = [String: Message]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 58, right: 0)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponents()
        
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatCollectionViewCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        print("index path item",indexPath.item)
        print ("message details",message.fromId, message.toId,message.text)
  
        
        if message.fromId == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = UIColor.systemBlue
        }
        else {
            cell.bubbleView.backgroundColor = UIColor.gray
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            
        }
//        cell.bubbleViewWidthAnchor?.constant = 50
        cell.bubbleViewWidthAnchor?.constant = textFrameEstimate(text: message.text).width + 50
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
         let text = messages[indexPath.item].text
            height = textFrameEstimate(text: text).height + 20
        
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func textFrameEstimate(text:String) ->CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 19)!] , context: nil)
    }
    
    func setupInputComponents(){
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
     // adding constraints x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        // adding constraints to send button x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        

        containerView.addSubview(inputTextField)
        // adding constraints x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = UIColor.gray
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView )
        
            // adding constraints x,y,w,h
        seperatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    
    }
    
    @objc func handleSend() {
       let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        let toId = contact!.id
        let fromId = Auth.auth().currentUser!.uid
        let sentAt =  NSNumber(value: Int(NSDate().timeIntervalSince1970))
        let values = ["text": inputTextField.text!,"toId": toId, "fromId": fromId, "sentAt": sentAt] as [String : Any]
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print (error!)
                return
            }
            self.inputTextField.text = nil
            
            guard let messageId = childRef.key else { return }
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(messageId)
            userMessagesRef.setValue(1)
            
            
            let recipientMessageRef = Database.database().reference().child("user-messages").child(toId).child(messageId)
            recipientMessageRef.setValue(1)
             print("message id", messageId)
            print("userMessagesRef", userMessagesRef)
            print("recipientMessageRef", recipientMessageRef)
            print("message sent")

        }
    }
 
    
    func observeUserMessages() {

        guard let uid = Auth.auth().currentUser?.uid else { return }
             let userMessageTaggedRef = Database.database().reference().child("user-messages").child(uid)
        userMessageTaggedRef.observe(.childAdded, with: { (DataSnapshot) in

                  print("DataSnapshot", DataSnapshot)
            print("uid", uid)
                  let messageTagId = DataSnapshot.key
                    let MessageTaggedRef = Database.database().reference().child("messages").child(messageTagId)
                  MessageTaggedRef.observeSingleEvent(of: .value, with:{(snapshot) in
                      //print("Messages snapshot", DataSnapshot)
                      print("snapshot",snapshot)
                      if let childSnapshot = snapshot as? DataSnapshot,
                         let dict = childSnapshot.value as? [String:Any]{
                        print("messageTagId", messageTagId)
                          print("dict", dict);
                        
                          let fromId = dict["fromId"] as? String
                          let text = dict["text"] as? String
                          let sentAt = dict["sentAt"] as? NSNumber
                          let toId = dict["toId"] as? String
                        print("toId", self.contact!.id)
                        let message = Message(fromId: fromId!, text: text!, sentAt: sentAt! , toId: toId!)

                        if message.chatPartnerId() == self.contact?.id {
                         self.messages.append(message)
                            print("chatpartnerId messages"	)
                          DispatchQueue.main.async(execute: { () -> Void in
                          self.collectionView.reloadData()
                        })

                        }
                    }
                  }, withCancel: nil)

    }, withCancel: nil)

    }

    }

