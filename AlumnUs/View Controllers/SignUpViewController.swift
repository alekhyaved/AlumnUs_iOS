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

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var sjsuIDTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapTochangeProfile: UIButton!
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
     let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         setUpElements()
        
        imagePicker.delegate = self
    }
    
    func setUpElements(){
        errorLabel.alpha = 0
        
        Utilities.styleTextField(sjsuIDTextField)
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButtonLogin(loginButton)
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
    
    @IBAction func loginTapped(_ sender: Any) {
        
           // self.dismiss(animated: false, completion: nil)
        let controller = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController)
        self.view.window?.rootViewController = controller
        self.view.window?.makeKeyAndVisible()
        
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
            guard let profileImage = profileImageView.image else { return }
        //User creation
            Auth.auth().createUser(withEmail: email, password: pass) { (result, err) in
                if err != nil{
                    self.showError("Error occurred while cretaing a new user account")
                }
                else {
                    // load user data into Firebase Database
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["SJSUID" : sjsuid, "firstname": firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil{
                            self.showError("User entry cannot be created on database.")
                        }
                    }
                    
                    // Upload the profile image to Firebase Storage and Real-time database
                    self.uploadProfileImage(profileImage) { url in
                        if url != nil {
                               self.saveProfile(profileImageURL: url!) { success in
                              if success {
                                    self.dismiss(animated: true, completion: nil)
                                  }
                            }
                        } else {
                            // Error unable to upload profile image
                        }
                        
                    }
                    
                     //move to home screen
                    self.moveToHome()
                    
                }
            }
        }
    }
    
    //upload profile image to Firebase Storage
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
       guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {

            storageRef.downloadURL { url, error in
                completion(url)
                // success!
                }
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
    // Load profile image data into Firebase Database
    func saveProfile(profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "photoURL": profileImageURL.absoluteString
        ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    func showError(_ message: String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func moveToHome(){
        let controller =  storyboard?.instantiateViewController(identifier: Constants.Storyboard.mainTabBarController)
        as? UITabBarController
        
        view.window?.rootViewController = controller
        view.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func tapToChangeTapped(_ sender: Any) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
            
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
}

