//
//  ChatCollectionViewCell.swift
//  AlumnUs
//
//  Created by Leela Alekhya Vedula on 4/14/20.
//  Copyright © 2020 Alekhya. All rights reserved.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    
    let textView: UITextView = {
        let textV = UITextView()
        textV.text = "Sample Text For NOw"
        textV.font = UIFont.systemFont(ofSize: 16)
        textV.backgroundColor = UIColor.clear
        textV.textColor = .white
        textV.translatesAutoresizingMaskIntoConstraints = false
        return textV
        
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    var bubbleViewWidthAnchor : NSLayoutConstraint?
    var bubbleViewRightAnchor : NSLayoutConstraint?
    var bubbleViewLeftAnchor  : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
       addSubview(bubbleView)
       addSubview(textView)
            textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
            textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
            textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//            textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            
        
            bubbleViewWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
            bubbleViewWidthAnchor?.isActive = true
        
        
            bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -8 )
            bubbleViewRightAnchor?.isActive = true
            
            bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8 )
//            bubbleViewLeftAnchor?.isActive = false
        
        
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
           
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
