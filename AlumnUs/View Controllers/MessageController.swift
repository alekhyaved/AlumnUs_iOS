//
//  MessageController.swift
//  AlumnUs
//
//  Created by Leela Alekhya Vedula on 4/2/20.
//  Copyright © 2020 Alekhya. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase



class MessageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count

  }
    

    func showChatControllerForContact(contact: Profile){
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.contact = contact
        navigationController?.pushViewController(chatLogController, animated: true)
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "chatSegue", sender: self)
        dismiss(animated: true)
        {
            let contact = self.contacts[indexPath.row]
            print("dismiss completed")
            self.showChatControllerForContact(contact: contact)
        }
    }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! ContactsTableViewCell
    cell.set(contact: contacts[indexPath.row])
    return cell
    }
 
    var tableView: UITableView!
    var moreFetching = false
        var reachedEnd = false
    let leadingScreenForBatchhing:CGFloat = 3.0
       
//     let eventRequest = NSFetPchRequest<NSFetchRequestResult>(entityName: "Profile")
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    var contacts = [Profile]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        
   tableView = UITableView(frame: view.bounds, style: .plain)
   
   let cellNib = UINib(nibName: "ContactsTableViewCell", bundle: nil)
   tableView.register(cellNib, forCellReuseIdentifier: "contactCell")
        tableView.backgroundColor = UIColor(white: 0.90,alpha:1.0)
   view.addSubview(tableView)
   
   var layoutGuide:UILayoutGuide!
   
   if #available(iOS 11.0, *) {
       layoutGuide = view.safeAreaLayoutGuide
   } else {
       // Fallback on earlier versions
       layoutGuide = view.layoutMarginsGuide
   }
   
   tableView.translatesAutoresizingMaskIntoConstraints = false
   tableView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor).isActive = true
   tableView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
   tableView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor).isActive = true
   tableView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true

              tableView.delegate = self
              tableView.dataSource = self
              tableView.reloadData()

        
  
            let profileRef = Database.database().reference().child("users").child("profile")
            
            var queryRef: DatabaseQuery
            queryRef = profileRef.queryLimited(toLast: 20)
            queryRef.observeSingleEvent(of: .value, with: { snapshot in
//                var tempContacts = [Profile]()
            for child in snapshot.children {
              //  print("child", child)
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let username = dict["username"] as? String,
                    let id = childSnapshot.key as? String,
                    let photoURL = dict["photoURL"] as? String,
                    let url = URL(string:photoURL){
                    let profile = Profile(username: username, photoURL: url, id: id)
                    self.contacts.append(profile)
                    
                    print("dict", dict)
                    print("id", id)
                    print("key", childSnapshot.key)
                    
//                    tempContacts.append(profile)
                }

            }
                self.tableView.reloadData()

                }

            )

        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

    







    
 

