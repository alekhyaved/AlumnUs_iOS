//
//  NewPostViewController.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/16/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class NewPostViewController: UIViewController, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    //@IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var addPhotoImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var imageurl: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

       textArea.delegate = self
        imagePicker.delegate = self
        
    }
    
    func  setUpElements() {
        Utilities.styleFilledPostButton(postButton)
    }
    
//    @IBAction func cancelTapped(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
   override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           textArea.becomeFirstResponder()
       }
    
    func textViewDidChange(_ textArea: UITextView){
        placeHolderLabel.isHidden = !textArea.text.isEmpty
    }
    
    
    @IBAction func addPhotosTapped(_ sender: Any) {
        imagePicker.allowsEditing = true
               imagePicker.sourceType = .photoLibrary
                   
               present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addPhotoImageView.contentMode = .scaleAspectFit
            addPhotoImageView.image = pickedImage
            imageurl = info[UIImagePickerController.InfoKey.imageURL]
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    

    
    
    @IBAction func postButtonTapped(_ sender: Any) {
         guard let addphoto = addPhotoImageView.image else { return }
        
        self.uploadAddPhotoImage(addphoto){ url in
            guard let userProfile = UserService.currentUserProfile else {return}
            
                let postRef = Database.database().reference().child("posts").childByAutoId()
                
                let postObject = [
                    "author": [
                        "uid": userProfile.uid,
                        "username": userProfile.username,
                        "photoURL": userProfile.photoURL.absoluteString
                    ],
                    
                    "text" : self.textArea.text!,
                    "timestamp" : [".sv":"timestamp"],
                    "addPhotoURL": url?.absoluteString
                ] as [String: Any]
                
                postRef.setValue(postObject, withCompletionBlock: { error, ref in
                    if error == nil {
                        self.dismiss(animated: true, completion: nil)
                    }
                    else{
                        //handle error
                    }
                })

        }
        
            
    }
    
    //upload profile image to Firebase Storage
    func uploadAddPhotoImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user-posts-image/\(String(describing: imageurl))")
        
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
    
    
}
