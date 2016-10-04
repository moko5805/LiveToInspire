//
//  CreateProfileCell.swift
//  Inspire
//
//  Created by Mostafa S Taheri on 10/2/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit

class CreateProfileCell: UITableViewCell {
    
    @IBOutlet weak var myTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: String?, placeholder: String?) {
        
        myTextField.text = data
        myTextField.placeholder = placeholder
    }

}
