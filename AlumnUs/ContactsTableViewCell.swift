//
//  ContactsTableViewCell.swift
//  AlumnUs
//
//  Created by Arno Lenin Malyala on 4/13/20.
//  Copyright © 2020 Juhi Nayak. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    
    @IBOutlet weak var contactName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    weak var contact: Profile?
    
       func set(contact:Profile) {
        self.contact = contact
         
        self.profileImageView.image = nil
        imageService.getImage (withURL: contact.photoURL){image, url in
            guard let _contact = self.contact else { return }
            if _contact.photoURL.absoluteString == url.absoluteString{
                self.profileImageView.image = image
            }
            else {
                print("image not available")
            }
            
            
        }

        contactName.text = contact.username
      
        
    }
    
  
    
}
