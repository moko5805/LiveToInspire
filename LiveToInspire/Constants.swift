//
//  Constants.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 7/25/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import Foundation
import UIKit

let SHADOW_COLOR: CGFloat = 157.0 / 255.0

//Keys
let KEY_UID = "uid"

//Segues Identifier 
let SEGUE_LOGGED_IN = "loggedin"

//Status Codes
let STATUS_CODE_ACCOUNT_NONEXIST = -8











//@IBAction func attemptLogin(sender: UIButton!) {
//    
//    if let email = emailFiled.text where email != "", let pwd = passwordField.text where pwd != "" {
//        
//        FIRAuth.auth()?.signInWithEmail(email, password: pwd) { (user, error) in
//            
//            if error != nil {
//                
//                //to find out the error code for nonexisted accounts
//                print(error)
//                if error!.code == STATUS_CODE_ACCOUNT_NONEXIST {
//                    
//                    //Create user
//                    FIRAuth.auth()?.createUserWithEmail(email, password: pwd) { (user, error) in
//                        
//                        if error != nil {
//                            
//                            self.showErrorAlert("could not create account", msg: "problem creating account, try something else")
//                            
//                        } else {
//                            if let user = user {
//                                
//                                let userData = ["provider": user.providerID]
//                                
//                                FIRAuth.auth()?.signInWithEmail(email, password: pwd, completion: { (nil) in
//                                    
//                                })
//                                print("created and authenticated Firebase user at this point")
//                                self.completeSignIn(user.uid, userData: userData)                                }
//                        }
//                    }
//                    
//                } else {
//                    self.showErrorAlert("could not login", msg: "please check your username or password")
//                }
//                
//            } else {
//                if let user = user {
//                    let userData = ["provider": user.providerID]
//                    print("email user authenticated with Firebase")
//                    self.completeSignIn(user.uid, userData: userData)
//                }
//            }
//            
//        }
//        
//    } else {
//        showErrorAlert("Email and Password Required", msg: "You Must Enter Email and Password")
//    }
//    
//}