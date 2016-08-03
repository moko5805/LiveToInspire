//
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


class SignInVC: UIViewController {
    
    @IBOutlet weak var emailFiled: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //if user is already logged in go to the next VC and not the log in page
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    //I will create a custom view for my facebook login button and this will become an IBAction
    @IBAction func fbLoginBtnPressed(sender: UIButton!) {
        let facebookLogin: FBSDKLoginManager = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["public_profile","email","user_friends"], fromViewController: presentedViewController) { (fbResult, fbError) in
            if fbError != nil {
                print("Facebook login failed!\(fbError)")
            } else {
                //get an access token for the signed-in user
                if let accessToken = FBSDKAccessToken.currentAccessToken().tokenString {
                    print("Successfully logged in to Facebook\(accessToken)")
                    //and exchange it for a Firebase credential
                    let credential = FIRFacebookAuthProvider.credentialWithAccessToken(accessToken)
                    
                    //authenticate with Firebase using the Firebase credential
                    FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                        if error != nil {
                            print("Login failed\(error)")
                            //create alert center later
                        } else {
                            print("user logged in to Firebase witj user id \(user!.uid)")
                            NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailFiled.text where email != "", let pwd = passwordField.text where pwd != "" {
            
            FIRAuth.auth()?.signInWithEmail(email, password: pwd) { (user, error) in
                
                if error != nil {
                    
                    //to find out the error code for nonexisted accounts
                    print(error)
                    
                    if error!.code == STATUS_CODE_ACCOUNT_NONEXIST {
                        
                        //Create user
                        FIRAuth.auth()?.createUserWithEmail(email, password: pwd) { (user, error) in
                            
                            if error != nil {
                                self.showErrorAlert("could not create account", msg: "problem creating account, try something else")
                            } else {
                                NSUserDefaults.standardUserDefaults().setValue(user!.uid, forKey: KEY_UID)
                                
                                FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (nil) in
                                    
                                })
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                
                            }
                        }
                    } else {
                        self.showErrorAlert("could not login", msg: "please check your username or password")
                    }
                    
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            }
            
        } else {
            showErrorAlert("Email and Password Required", msg: "You Must Enter Email and Password")
        }
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}




