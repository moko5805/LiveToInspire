//
//  EditProfileCell.swift
//  Inspire
//
//  Created by Mostafa S Taheri on 9/3/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit

class EditProfileCell: UITableViewCell {
    
    
    @IBOutlet weak var myTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(text:String?, placeholder:String?) {
        
        myTextField.text = text
        myTextField.placeholder = placeholder
        
    }
    
    
}
