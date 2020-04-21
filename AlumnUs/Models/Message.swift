//
//  Message.swift
//  AlumnUs
//
 //  Created by Leela Alekhya Vedula on 4/16/20.
 //  Copyright © 2020 Alekhya. All rights reserved.

import Foundation
import Firebase

class Message{
    var fromId: String
    var text: String
    var sentAt: NSNumber
    var toId: String

 func chatPartnerId() -> String? {

           if fromId == Auth.auth().currentUser?.uid {
               return toId
           }
           else{
              return fromId
           }

       }
    
    init(fromId: String, text: String, sentAt : NSNumber, toId: String) {
        self.fromId = fromId
        self.text = text
        self.sentAt = sentAt
        self.toId = toId
    
        
    }
}

