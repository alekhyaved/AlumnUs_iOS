//
//  Post.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/16/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation


class Post {
    var id:String
    var author:UserProfile
    var text:String
    var createdAt:Date
    var addedPhotoURL: URL
    
    init(id:String, author:UserProfile,text:String, timestamp:Double, addedPhotoURL: URL) {
        self.id = id
        self.author = author
        self.text = text
        self.createdAt = Date(timeIntervalSince1970: timestamp / 1000)
        self.addedPhotoURL = addedPhotoURL
    }
    
    static func parse(_ key:String, _ data:[String:Any]) -> Post? {
        
        if
            let author = data["author"] as? [String:Any],
            let uid = author["uid"] as? String,
            let username = author["username"] as? String,
            let photoURL = author["photoURL"] as? String,
            let url = URL(string:photoURL),
            let text = data["text"] as? String,
            let timestamp = data["timestamp"] as? Double,
            let addedPhoto = data["addPhotoURL"] as? String,
            let addURL = URL(string: addedPhoto){
            
             let userProfile = UserProfile(uid: uid, username: username, photoURL: url)
            return Post(id: key, author: userProfile, text: text, timestamp:timestamp, addedPhotoURL: addURL)
            
        }
        
        return nil
        
    }
}
