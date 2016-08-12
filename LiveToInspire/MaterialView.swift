//
//  MaterialView.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 8/6/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit

class MaterialView: UIView {

    class MaterialView: UIView {
        
        override func awakeFromNib() {
            layer.cornerRadius = 2.0
            layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
            layer.shadowOpacity = 0.8
            layer.shadowRadius = 0.5
            layer.shadowOffset = CGSizeMake(0.0, 3.0)
            
        }
        
    }


}
