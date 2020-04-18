//
//  Utilities.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/5/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import Foundation
import UIKit


class Utilities : UIViewController {
    
    static func styleTextField(_ textfield:UITextField){
       
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x:0, y: textfield.frame.height-2, width: textfield.frame.width, height: 2 )
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)

    }
    
    static func styleFilledButton (_ button:UIButton){
        button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        
    }
    
    static func styleFilledPostButton (_ button:UIButton){
        button.backgroundColor = UIColor.init(red: 48/255, green: 99/255, blue: 173/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
        
    }
    
    static func styleHollowButton(_ button:UIButton){
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleHollowButtonLogin(_ button:UIButton){
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.cornerRadius = 20.0
        button.tintColor = UIColor.blue
    }
    
    static func isPasswordValid(_ password: String) -> Bool {
        let pass = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$!%*?&])([A-Za-z\\d$@$#!%*?&]){8,}")
        return pass.evaluate(with: password)
    }
    
    static func isEmailValid(_ email: String) -> Bool {
        let emailDomain = "@sjsu.edu"
        var result = false
        if email.contains(emailDomain){
            result = true
        }
        return result
    }
    
}


extension Date
{
    func calenderTimeSinceNow() -> String
    {
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        
        let years = components.year!
        let months = components.month!
        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!
        
        if years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        } else if months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        } else if days >= 7 {
            let weeks = days / 7
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        } else if days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return seconds == 1 ? "1 second ago" : "\(seconds) seconds ago"
        }
    }
    
}

