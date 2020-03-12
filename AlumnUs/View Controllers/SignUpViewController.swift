//
//  SignUpViewController.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/4/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var sjsuIDTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         setUpElements()
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        
        Utilities.styleTextField(sjsuIDTextField)
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
    }
    
    
    func validateFields() -> String?{
        if sjsuIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
            return "Please fill in all fields!!"
        }
        
        // password validation
        
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(pass) == false {
            return "Password must be of 8 characters, should conatin a special character and a number."
        }
        
        
        return nil
    }
    

    @IBAction func signUpTapped(_ sender: Any) {
        // fields validation
        let error = validateFields()
        if error != nil {
            showError(error!)
        }
        else
        {
            
        // remove whitespaces from text
            let sjsuid = sjsuIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //User creation
            Auth.auth().createUser(withEmail: email, password: pass) { (result, err) in
                if err != nil{
                    self.showError("Error occurred while cretaing a new user account")
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["SJSUID" : sjsuid, "firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil{
                            self.showError("User entry cannot be created on database.")
                        }
                    }
                    
                     //move to home screen
                    self.moveToHome()
                    
                }
            }
        }
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func moveToHome(){
       let homeViewC =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeviewController)
        as? HomeViewController
        
        view.window?.rootViewController = homeViewC
        view.window?.makeKeyAndVisible()
    }
    

}
