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

//
//var tableView:UITableView!
////var contacts = users[]()
//var moreFetching = false
//    var reachedEnd = false
//let leadingScreenForBatchhing:CGFloat = 3.0
   


class MessageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
  }
  
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
    
    //let cell = self.tableView.cellForRow(at: indexPath)
      
    let contact = contacts[indexPath.row]
    cell?.textLabel?.text = contact.username
    
    

//    DispatchQueue.global().async { [weak self] in
//        if let data = try? Data(contentsOf: contact.photoURL) {
//            if let image = UIImage(data: data) {
//                DispatchQueue.main.async {
//                   // self?.image = image
//                    print("The loaded image: \(image)")
//                    cell?.imageView?.image = image
//                }
//            }
//        }
//    }
    

    return cell!
    }
 
    @IBOutlet weak var tableView: UITableView!
//     let eventRequest = NSFetPchRequest<NSFetchRequestResult>(entityName: "Profile")
    var ref: DatabaseReference?
    var databaseHandle: DatabaseHandle?
    
    var contacts = [Profile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
   
     //set reference to database
        let profileRef = Database.database().reference().child("users").child("profile")
       // var queryRef: DatabaseQuery
       // queryRef.observeSingleEvent(of: .value, with: { snapshot in
       
        //Retrieve contact list
//        databaseHandle = ref?.child("users").observe(.childAdded, with: { (snapshot) in
        var queryRef: DatabaseQuery
        queryRef = profileRef.queryLimited(toLast: 20)
        queryRef.observeSingleEvent(of: .value, with: { snapshot in
         
        //Code to execute to retrieve users
        //Try to convert he value of the data into a string
//     let contactList = snapshot.value
//            print("Contact list snapshot value", contactList as Any)
           // let  actualContact = self.contacts.append(contactList! as! String)
//      if let actualContact = contactList{
//            print("actualContacts are",actualContact)
//            //Append data to our contacts Array
//
        for child in snapshot.children {
          //  print("child", child)
            if let childSnapshot = child as? DataSnapshot,
                let dict = childSnapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string:photoURL){
                let profile = Profile(username: username, photoURL: url)
                self.contacts.append(profile)
            }
                
            
        }
            
//        self.contacts.append(actualContact as! String)
      //  print("contacts appended " )
            //Reload the table view
           self.tableView.reloadData()
            }
        //}
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

extension ViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print("you tapped table")
    }
}


//extension ViewController : UITableViewDataSource{
    
 

