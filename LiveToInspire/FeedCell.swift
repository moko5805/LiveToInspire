//
//  FeedCell.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 7/30/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var likesLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func drawRect(rect: CGRect) {
        //perfect circle
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        postImg.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
