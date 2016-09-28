//
//  EditProfileTableViewController.swift
//  Inspire
//
//  Created by Mostafa S Taheri on 9/3/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    
    var about = ["DisplayName","Gender", "Age", "Phone", "Email", "Website", "Bio"]
    
    let user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //what is this for?
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        DataService.ds.REF_USER_PROFILES.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            let usersDict = snapshot.value as! NSDictionary
            print(usersDict)
            
            //to capture the data associated to this particular UID
            let userDetails = usersDict.objectForKey(self.user!.uid)
            print(userDetails)
            
            for index in 0...self.about.count {
                
                let indexpath = NSIndexPath(forRow: index, inSection: 0)
                if let cell = self.tableView.cellForRowAtIndexPath(indexpath) as? EditProfileCell {
                    
                    let field = (cell.myTextField.placeholder?.lowercaseString)!
                    
                    switch field {
                    case "displayname":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("displayname") as? String, placeholder: "Display Name")
                    case "gender":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("gender") as? String, placeholder: "Gender")
                    case "age":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("age") as? String, placeholder: "Age")
                    case "phone":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("phone") as? String, placeholder: "Phone")
                    case "email":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("email") as? String, placeholder: "Emial")
                    case "website":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("website") as? String, placeholder: "Website")
                    case "bio":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("bio") as? String, placeholder: "Bio")
                        
                    default:
                        ""
                    }
                    
                }
                
            }
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width/2
        self.profilePic.clipsToBounds = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return about.count
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EditProfileCell", forIndexPath: indexPath) as! EditProfileCell
        
        cell.configureCell("", placeholder: "\(about[(indexPath as NSIndexPath).row])")
        
        return cell
    }
    
    @IBAction func onCancelTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapUpdate(sender: AnyObject) {
        
        for index in 0...about.count {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? EditProfileCell {
                
                if let item = cell.myTextField.text  where item != "" {
                    
                    switch about[index] {
                        
                    case "DisplayName":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/displayname").setValue(item)
                        
                    case "Gender":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/gender").setValue(item)
                        
                    case "Age":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/age").setValue(item)
                        
                    case "Phone":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/phone").setValue(item)
                        
                    case "Email":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/email").setValue(item)
                        
                    case "Website":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/website").setValue(item)
                        
                    case "Bio":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/bio").setValue(item)
                        
                    default:
                        print("dont update")
                    }//end switch
                }//end if
                
            }
            
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
