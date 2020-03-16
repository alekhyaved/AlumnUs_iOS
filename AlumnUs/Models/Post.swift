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
    var author:String
    var text:String
    
    init(id:String, author:String,text:String) {
        self.id = id
        self.author = author
        self.text = text
    }
}
