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
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let user = FIRAuth.auth()?.currentUser
        
            if user != nil {
                // User is signed in. send the user to home screen
                
                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                
            } else {
                // No user is signed in. Show the user login page
                
                self.loginButton.readPermissions = ["public_profile", "email", "user_friends"]
                self.loginButton.delegate = self
                self.view!.addSubview(self.loginButton)
                
                self.loginButton.hidden = false
            }
        
        self.loginButton.frame = CGRect(x: 73, y: 480, width: 230, height: 30)
        
        let framex = loginButton.frame
        print("X POSITION \(framex.origin.x)")
        print("Y POSITION \(framex.origin.y)")
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
    
    @IBAction func attemptLogin(sender: UIButton!) {
        
        if let email = emailFiled.text  where email != "", let pwd = passwordField.text  where pwd != "" {
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (user, error) in

                if error == nil {
                    print("email user authenticated with Firebase")
                    
                } else {
                    self.showErrorAlert("Username or password incorrect!", msg: "Please try again...")
                }
            })
        } else {
            showErrorAlert("Email and Password Required", msg: "You Must Enter Email and Password")
        }
        
    }
    
    func finalizeSignIn(userUid: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseUserProfile(userUid, userData: userData)
        
        performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}




