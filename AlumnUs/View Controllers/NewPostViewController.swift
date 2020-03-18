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

class NewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textArea: UITextView!
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       textArea.delegate = self
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           textArea.becomeFirstResponder()
       }
    
    func textViewDidChange(_ textArea: UITextView){
        placeHolderLabel.isHidden = !textArea.text.isEmpty
    }
    
    
    @IBAction func postButtonTapped(_ sender: Any) {
        
        guard let userProfile = UserService.currentUserProfile else {return}
    
        let postRef = Database.database().reference().child("posts").childByAutoId()
        
        let postObject = [
            "author": [
                "uid" : userProfile.uid,
                "username": userProfile.username,
                "photoURL": userProfile.photoURL.absoluteString
            ],
            "text" : textArea?.text as Any,
            "timestamp" : [".sv":"timestamp"]
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
