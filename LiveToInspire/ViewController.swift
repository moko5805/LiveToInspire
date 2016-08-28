//  ViewController.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 7/24/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var emailFiled: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var loginButton: FBSDKLoginButton = FBSDKLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.hidden = true
        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, user in
            if let user = user {
                // User is signed in. send the user to home screen
                
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                
            } else {
                // No user is signed in. Show the user login page
                
                self.loginButton.center = self.view.center
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.view!.addSubview(self.loginButton)
                
                self.loginButton.hidden = false
            }
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            //handle errors here
            print("Unable to authenticate with Facebook - \(error)")
            self.loginButton.hidden = false
            
        } else if result.isCancelled == true {
            //hanlde cancel event
            print("user canceled Facebook authentication")
            self.loginButton.hidden = false
            
        } else {
            
            print("User Logged In")
            
            self.loginButton.hidden = true
            
            //now that we authenticated with FB let's authenticate with Firebase
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
                if error != nil {
                    print("unable to authenticate with Firebase")
                } else {
                    print("successfully authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": credential.provider, "displayname": user.displayName!, "email": user.email!]
                        self.finalizeSignIn(user.uid, userData: userData)
                    }
                    
                  }
            }
            
          }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        //if user is already logged in go to the next VC and not the log in page
//        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
//            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
//        }
//    }
    
//    //I will create a custom view for my facebook login button and this will become an IBAction
//    @IBAction func fbLoginBtnPressed(sender: UIButton!) {
//        
//        let facebookLogin = FBSDKLoginManager()
//        
//        facebookLogin.logInWithReadPermissions(["public_profile","email"], fromViewController: self) { (result, error) in
//            if error != nil {
//                print("Unable to authenticate with Facebook - \(error)")
//            } else if result.isCancelled == true {
//                print("user canceled Facebook authentication")
//            } else {
//                print("Successfully authenticated with Facebook")
//                print("result\(result)")
//                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
//                //now that we authenticated with FB let's authenticate with Firebase
//                self.firebaseAuthenticate(credential)
//                
//            }
//        }
//    }
    
//    func firebaseAuthenticate(credential: FIRAuthCredential) {
//        FIRAuth.auth()?.signInWithCredential(credential, completion: { (user, error) in
//            if error != nil {
//                print("unable to authenticate with Firebase")
//            } else {
//                print("successfully authenticated with Firebase")
//                if let user = user {
//                    let userData = ["provider": credential.provider]
//                    self.completeSignIn(user.uid, userData: userData)
//                }
//                
//             }
//        })
//    }
    
//    @IBAction func attemptLogin(sender: UIButton!) {
//        
//        if let email = emailFiled.text where email != "", let pwd = passwordField.text where pwd != "" {
//            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user, error) in
//                if error == nil {
//                    print("email user authenticated with Firebase")
//                    if let user = user {
//                        let userDate = ["provider": user.providerID]
//                        self.completeSignIn(user.uid, userData: userDate)
//                    }
//                } else {
//                    FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
//                        if error != nil {
//                            print("unable to authenticated email using with Firebase")
//                        } else {
//                            print("successfully created new user and authenticated with Firebase")
//                            if let user = user {
//                                let userData = ["provider": user.providerID]
//                                self.completeSignIn(user.uid, userData: userData)
//                            }
//                            
//                        }
//                    })
//                }
//            })
//        }
//            
//    }
    
//    func completeSignIn(userUid: String, userData: Dictionary<String, String>) {
//        
//        DataService.ds.createFirebaseDBUser(userUid, userData: userData)
//        
//        NSUserDefaults.standardUserDefaults().setValue(userUid, forKey: KEY_UID)
//        print("Data/user uid was saved to the disk")
//        performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
//    }
    
    func finalizeSignIn(userUid: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseUserProfile(userUid, userData: userData)
        
        performSegueWithIdentifier("testVC", sender: nil)
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}




