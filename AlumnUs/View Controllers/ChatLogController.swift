//
//  ChatLogController.swift
//  AlumnUs
//
//  Created by Arno Lenin Malyala on 4/14/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var contact: Profile? {
        didSet{
            navigationItem.title = contact?.username
            observeMessages()
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
        if message.fromId == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = UIColor.systemBlue
        }
        else {
            cell.bubbleView.backgroundColor = UIColor.gray
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
        
        
//        let inputTextField = UITextField()
//        inputTextField.placeholder = "Enter message..."
//        inputTextField.translatesAutoresizingMaskIntoConstraints = false
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
        let sentAt:NSNumber =  NSNumber(value: Int(NSDate().timeIntervalSince1970))
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
             print("message id", messageId)
            print("userMessagesRef", userMessagesRef)
            print("message sent")

        }
    }
    
//    func observeUserMessages() {
//
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//             let userMessageTaggedRef = Database.database().reference().child("user-messages").child(uid)
//        userMessageTaggedRef.observe(.childAdded, with: { (DataSnapshot) in
//
//                  print("DataSnapshot", DataSnapshot)
//                  let messageTagId = DataSnapshot.key
//                    let MessageTaggedRef = Database.database().reference().child("messages").child(messageTagId)
//                  MessageTaggedRef.observeSingleEvent(of: .value, with:{
//                      (snapshot) in
//                      //print("Messages snapshot", DataSnapshot)
//                      print("snapshot",snapshot)
//                      if let childSnapshot = snapshot as? DataSnapshot,
//                         let dict = childSnapshot.value as? [String:Any]{
//
//                          print("dict", dict);
//
//                          let fromId = dict["fromId"] as? String
//                          let text = dict["text"] as? String
//                          let timeStamp = dict["timeStamp"] as? NSNumber
//                          let toId = dict["toId"] as? String
//                          print("fromId", fromId!)
//                          print("text", text!)
//                          print("sentAt", timeStamp )
//                          print("toId", toId)
//                        let message = Message(fromId: fromId!, text: text!, timeStamp: timeStamp! , toId: toId!)
//                        //message.setValuesForKeys(dictionaryWithValues(forKeys: dict))
//                        //  message.setValuesForKeys(dict)
//                          print("printing message text", message.text )
//                          self.messages.append(message)
//
//                        if let toId = message.toId {
//                            self.messageDictionary[toId!] = message
//                            self.messages = Array (self.messageDictionary.values)
//                            self.messages.sort (by: { (message1, message2) ->
//                                Bool in
//
//                                return message1.timeStamp.intValue > message2.timeStamp.intValue
//                            })
//
//                            }
//                    }
//                          DispatchQueue.main.async(execute: { () -> Void in
//                               self.collectionView.reloadData()
//                          })
//
//                  }, withCancel: nil)
//
//    }, withCancel: nil)
//
//    }
    
    func observeMessages() {
     guard let uid = Auth.auth().currentUser?.uid else { return }
        let userMessageTaggedRef = Database.database().reference().child("user-messages").child(uid)
        userMessageTaggedRef.observe(.childAdded, with: { (DataSnapshot) in
            
            print("DataSnapshot", DataSnapshot)
            let messageTagId = DataSnapshot.key
              let MessageTaggedRef = Database.database().reference().child("messages").child(messageTagId)
            MessageTaggedRef.observeSingleEvent(of: .value, with:{
                (snapshot) in
                //print("Messages snapshot", DataSnapshot)
                print("snapshot",snapshot)
                if let childSnapshot = snapshot as? DataSnapshot,
                   let dict = childSnapshot.value as? [String:Any]{
                        
                    print("dict", dict);
                
                    let fromId = dict["fromId"] as? String
                    let text = dict["text"] as? String
                    let timeStamp = dict["timeStamp"] as? NSNumber
                    let toId = dict["toId"] as? String
                    print("fromId", fromId!)
                    print("text", text!)
                    print("sentAt", timeStamp )
                    print("toId", toId!)
                    let message = Message(fromId: fromId!, text: text!, timeStamp: timeStamp! , toId: toId!)
                  //message.setValuesForKeys(dictionaryWithValues(forKeys: dict))
                  //  message.setValuesForKeys(dict)
                    print("printing message text", message.text )
                    self.messages.append(message)
                    DispatchQueue.main.async(execute: { () -> Void in
                         self.collectionView.reloadData()
                    })
                }
            }, withCancel: nil)
  
        }, withCancel: nil)
        
    }
        
    }
    
    


