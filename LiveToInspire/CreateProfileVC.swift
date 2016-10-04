//
//  CreateProfileVCViewController.swift
//  Inspire
//
//  Created by Mostafa S Taheri on 9/30/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateProfileVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passswordField: UITextField!
    
    var profile = ["DisplayName","Gender","Age","Phone","Website"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        
        self.profilePic.clipsToBounds = true
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let placeholder = profile[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("CreateProfileCell") as? CreateProfileCell {
            
            cell.configureCell("", placeholder: placeholder)
            
            return cell
        }
        
        return CreateProfileCell()
    }
    
    @IBAction func onCreateProfileTapped(sender: AnyObject) {
        
        if let email = emailField.text where email != "" , let pwd = passswordField.text where pwd != "" {
            
            FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { (user, error) in
                
                if error != nil {
                    
                    print("There is a problem creating Firebase account. Error Code: \(error!.code)")
                    
                    if error!.code == ERROR_CODE_WEAK_PASSWORD {
                        self.showErrorAlertX("Wait a minute...", msg: "WEAK PASSWORD!")
                    } else if error!.code == ERROR_CODE_EMAIL_IN_USE {
                        self.showErrorAlertX("Email address already exists", msg: "Try another one!")
                    } else if error!.code == ERROR_CODE_INVALID_EMAIL {
                        self.showErrorAlertX("Wait a minute...", msg: "Invalid email address entered!")
                    }
                    
                } else {
                    
                    if let user = user {
                        
                        let userData = ["provider": user.providerID, "email": user.email!]
                        
                        DataService.ds.createFirebaseUserProfile(user.uid, userData: userData)
                        
                        print("User account created in Firebase")
                        
                        for index in 0...self.profile.count {
                            
                            let indexpath = NSIndexPath(forRow: index, inSection: 0)
                            
                            if let cell = self.tableView.cellForRowAtIndexPath(indexpath) as? CreateProfileCell {
                                
                                if let data = cell.myTextField.text where data != "" {
                                    
                                    switch self.profile[index] {
                                        
                                    case "DisplayName":
                                        DataService.ds.REF_USER_PROFILES.child("\(user.uid)/displayname").setValue(data)
                                        print("DisplayName:\(data)")
                                        
                                    case "Gender":
                                        DataService.ds.REF_USER_PROFILES.child("\(user.uid)/gender").setValue(data)
                                        print("Gender:\(data)")
                                        
                                    case "Age":
                                        DataService.ds.REF_USER_PROFILES.child("\(user.uid)/age").setValue(data)
                                        print("Age:\(data)")
                                        
                                    case "Phone":
                                        DataService.ds.REF_USER_PROFILES.child("\(user.uid)/phone").setValue(data)
                                        print("Phone:\(data)")
                                        
                                    case "Website":
                                        DataService.ds.REF_USER_PROFILES.child("\(user.uid)/website").setValue(data)
                                        print("Website:\(data)")
                                        
                                    default:
                                        print("dont create")
                                        
                                    }//end switch
                                    
                                }//end if
                                
                            }
                            
                        }

                    }
                    
                      self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            })
            
        }
        
    }
    
    func showErrorAlertX(title: String, msg: String) {
        let alertX = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let actionX = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertX.addAction(actionX)
        presentViewController(alertX, animated: true, completion: nil)
    }

}
