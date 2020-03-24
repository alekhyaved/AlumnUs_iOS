//
//  LoginViewController.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/4/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
        passwordTextField.isSecureTextEntry = true
        
    }
    
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: pass, completion: {user, error in
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else{
                if self.authUser != nil && !self.authUser!.isEmailVerified {
                // User is available, but their email is not verified.
                    let alertController = UIAlertController(title: "Email not Verified", message: "Please verify your email by clicking on the link sent on your registered EmailID.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    
                    alertController.addAction(action)
                    
                    self.present(alertController, animated: true, completion: nil)
                
                }
                else{
                    let controller = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainTabBarController) as? UITabBarController
                                   
                                   self.view.window?.rootViewController = controller
                                   self.view.window?.makeKeyAndVisible()
                                   
                                   
                    }
                }
            })
            
        }
    
    @IBAction func createAccountTapped(_ sender: Any) {
        
        let controller = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.signUpViewController)
        self.view.window?.rootViewController = controller
        self.view.window?.makeKeyAndVisible()
        
    }
    
}
