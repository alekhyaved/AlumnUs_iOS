//
//  ProfileViewController.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 4/20/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {


    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailidLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    override func viewDidLoad() {
           super.viewDidLoad()

           // Do any additional setup after loading the view.
           setElements()
           setProfileImage()
           emailidLabel.text = authUser?.email
           
           
    }
   
    
    private var authUser : User? {
           return Auth.auth().currentUser
       }
    
    func setElements(){
        Utilities.styleFilledPostButton(aboutButton)
        Utilities.styleFilledButton(logoutButton)
    }
    
    func setProfileImage(){
       var ref:DatabaseReference!
       ref = Database.database().reference()
       let userid = authUser?.uid
       
       ref.child("users/profile").child(userid!).observeSingleEvent(of: .value, with: { (snapshot) in
               let value = snapshot.value as? NSDictionary
               let photoURL = value?["photoURL"] as? String ?? ""
               let url = URL(string:photoURL)
           
           imageService.getImage (withURL: url!){image, url in
                   self.profileImageView.image = image
            }
       })
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        try! Auth.auth().signOut()
               // self.performSegue(withIdentifier: "logOutSegue", sender: self)
               let mainViewC =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController)
               as? ViewController
               
               view.window?.rootViewController = mainViewC
               view.window?.makeKeyAndVisible()
               
    }
    
    @IBAction func aboutTapped(_ sender: Any) {
    }

    
    

                
    
    
    
    
    
    

    
}
