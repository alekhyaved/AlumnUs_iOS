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
    
}


