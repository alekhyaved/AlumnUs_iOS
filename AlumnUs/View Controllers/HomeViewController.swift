//
//  HomeViewController.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/4/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     
    @IBAction func logOutTapped(_ sender: Any) {
        
         try! Auth.auth().signOut()
        // self.performSegue(withIdentifier: "logOutSegue", sender: self)
        let mainViewC =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainViewController)
        as? ViewController
        
        view.window?.rootViewController = mainViewC
        view.window?.makeKeyAndVisible()
    }
       
        
    }


