//
//  ExtensionFuncs.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 8/20/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
