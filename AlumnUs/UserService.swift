//
//  UserService.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/17/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation
import Firebase

class UserService  {
    
    static var currentUserProfile: UserProfile?
    
    static func fethcUserData(_ uid: String, completion: @escaping ((_ userProfile: UserProfile?)->())){
        
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        
        userRef.observe(.value, with: {snapshot in
            var userProfile: UserProfile?
            
            if let userDict = snapshot.value as? [String: Any],
             let photoURL = userDict["photoURL"] as? String,
                let url = URL(string: photoURL){
                userProfile = UserProfile(uid: snapshot.key, photoURL: url)
            }
            completion(userProfile)
        })
    }
}
