//
//  UserProfile.swift
//  AlumnUs
//
//  Created by Leela Alekhya Vedula on 3/17/20.
//  Copyright © 2020 Alekhya. All rights reserved.
//

import Foundation

class Profile{
    var username: String
    var photoURL: URL
    
    init(username: String, photoURL: URL) {
        self.username = username
        self.photoURL = photoURL
    }
}


