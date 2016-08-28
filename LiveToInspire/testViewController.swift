//
//  testViewController.swift
//  Inspire
//
//  Created by Mostafa S Taheri on 8/27/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase

class testViewController: UIViewController {

    @IBOutlet weak var fbProfilePic: UIImageView!
    
    @IBOutlet weak var fbDisplayName: UILabel!
    
    @IBOutlet weak var fbEmail: UILabel!
    
    @IBOutlet weak var firebaseUserUid: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbProfilePic.layer.cornerRadius = self.fbProfilePic.frame.size.width/2

        self.fbProfilePic.clipsToBounds = true
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            let email = user.email
            let photoUrl = user.photoURL
            let uid = user.uid
            
            fbDisplayName.text = name
            fbEmail.text = email
            firebaseUserUid.text = uid
            
            
            if let photoData = NSData(contentsOfURL: photoUrl!) {
                self.fbProfilePic.image = UIImage(data: photoData)
            } else {
                print("there is no Facebook photo to display")
                self.fbProfilePic.hidden = true
            }
            
            
        } else {
            
            // No user is signed in.
        }

    }


}
