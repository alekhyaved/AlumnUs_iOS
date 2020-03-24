//
//  PostTableViewCell.swift
//  AlumnUs
//
//  Created by Juhi Nayak on 3/16/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
               profileImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var post:Post?
    
    func set(post:Post) {
        self.post = post
         
        self.profileImageView.image = nil
        imageService.getImage (withURL: post.author.photoURL){image, url in
            guard let _post = self.post else { return }
            if _post.author.photoURL.absoluteString == url.absoluteString{
                self.profileImageView.image = image
            }
            else {
                print("image not available")
            }
            
            
        }
        
        usernameLabel.text = post.author.username
        postTextLabel.text = post.text
        subTitleLabel.text = post.createdAt.calenderTimeSinceNow()
    }
    
}
