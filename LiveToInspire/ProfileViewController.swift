//  testViewController.swift
//  Inspire
//
//  Created by Mostafa S Taheri on 8/27/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var fbProfilePic: UIImageView!
    @IBOutlet weak var fbDisplayName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = FIRAuth.auth()?.currentUser {
            let name = user.displayName
            //let email = user.email
            //let photoUrl = user.photoURL
            let uid = user.uid
            
            fbDisplayName.text = name
            //fbEmail.text = email
            //firebaseUserUid.text = uid
            
            //reference to your particular storage service
            let profilePicRef = DataService.ds.REF_PROFILE_IMAGES.child(uid + "/Facebook-Profile-Picture.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            profilePicRef.dataWithMaxSize(1 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    
                    print("unable to download image from Firebase")
                    
                } else {
                    
                    if data != nil {
                        
                        print("user already has an image, no need to download from Facebook")
                        self.fbProfilePic.image = UIImage(data: data!)
                    }
                    
                }
            }
            
            
            if self.fbProfilePic.image == nil {
                
                //download image from Facebook and upload/stroe it in your Firebase Storage
                self.downloadUploadProfilePic(uid)
            }
            
            
        } else {
            
            // No user is signed in.
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.fbProfilePic.layer.cornerRadius = self.fbProfilePic.frame.size.width/2
        
        self.fbProfilePic.clipsToBounds = true
    }
    
    func downloadUploadProfilePic(uid: String) {
        let profilePic = FBSDKGraphRequest(graphPath: "me/picture", parameters: ["height":300,"width":300, "redirect": false], HTTPMethod: "GET")
        
        profilePic?.startWithCompletionHandler({(connection, result, error) -> Void in
            // Handle the result
            
            if error == nil {
                
                //print(result)
                
                let dictionary = result as? NSDictionary
                let data = dictionary?.objectForKey("data")
                
                let urlPic = data!.objectForKey("url")! as! String
                
                if let imageData = NSData(contentsOfURL: NSURL(string: urlPic)!) {
                    
                    let profilePicRef = DataService.ds.REF_PROFILE_IMAGES.child(uid + "/Facebook-Profile-Picture.jpg")
                    
                    profilePicRef.putData(imageData, metadata: nil) { metadata, error in
                        
                        if error == nil {
                            
                            //metadata contains size, content type and download url
                            let downloadUrl = metadata!.downloadURL
                            print(downloadUrl)
                            
                        } else {
                            print("error in downloading image")
                        }
                        
                        
                    }
                    
                    self.fbProfilePic.image = UIImage(data: imageData)
                    
                }
                
            }
            
        })
    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        
        //signs the user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        //sign the user out of the Facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        performSegueWithIdentifier("goToSignInpage", sender: nil)

    }
    
}



