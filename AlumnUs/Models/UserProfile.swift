//
//  UserProfile.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/17/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation

class UserProfile{
    var uid: String
    var username: String
    var photoURL: URL
    
    init(uid: String, username: String, photoURL: URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}


