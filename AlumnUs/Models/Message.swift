//
//  Message.swift
//  AlumnUs
//
//  Created by Arno Lenin Malyala on 4/14/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation
import Firebase

class Message{
    var fromId: String
    var text: String
    var timeStamp: String
    var toId: String

 
    
    init(fromId: String, text: String, timeStamp : String, toId: String) {
        self.fromId = fromId
        self.text = text
        self.timeStamp = timeStamp
        self.toId = toId
    
        func chatPartnerId() -> String? {
            
            if fromId == Auth.auth().currentUser?.uid {
                return toId
            }
            else{
               return fromId
            }
           
        }
        
        
   
    }
}

