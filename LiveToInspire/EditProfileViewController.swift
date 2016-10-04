
//  EditProfileTableViewController.swift
//  Inspire
//
//  Created by Mostafa S Taheri on 9/3/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePic: UIImageView!
    
    var about = ["DisplayName","Gender", "Age", "Phone","Website"]
    
    let user = FIRAuth.auth()?.currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        DataService.ds.REF_USER_PROFILES.observeEventType(FIRDataEventType.Value, withBlock: { (snapshot) in
            
            let usersDict = snapshot.value as! NSDictionary
            
            //just for the purpose of development. I shall come back here and delete this print command
            print(usersDict)
            
            //to capture the data associated to the current user (the user logged in NOW)
            let userDetails = usersDict.objectForKey(self.user!.uid)
            
            print("User Details: \(userDetails)")
            
            for index in 0...self.about.count {
                
                let indexpath = NSIndexPath(forRow: index, inSection: 0)
                if let cell = self.tableView.cellForRowAtIndexPath(indexpath) as? EditProfileCell {
                    
                    let placeholder = (cell.myTextField.placeholder)!
                    
                    switch placeholder {
                        
                    case "DisplayName":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("displayname") as? String, placeholder: "DisplayName")
                    case "Gender":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("gender") as? String, placeholder: "Gender")
                    case "Age":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("age") as? String, placeholder: "Age")
                    case "Phone":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("phone") as? String, placeholder: "Phone")
                    //case "Email":
                   // cell.configureCell((userDetails! as AnyObject).objectForKey("email") as? String, placeholder: "Emial")
                    case "Website":
                        cell.configureCell((userDetails! as AnyObject).objectForKey("website") as? String, placeholder: "Website")
                        
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
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath IndexPath: NSIndexPath) -> UITableViewCell {
        
        let placeholder = about[IndexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("EditProfileCell") as? EditProfileCell {
        
            cell.configureCell("", placeholder: placeholder)
            
            return cell
            
        } else {
            
            return EditProfileCell()
        }
        
    }
    
    @IBAction func didTapUpdate(sender: AnyObject) {
        
        for index in 0...about.count {
            
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? EditProfileCell {
                
                if let data = cell.myTextField.text  where data != "" {
                    
                    //let's say you are at the very first loop where index = 0
                    // switch about[0] which is equal to 'DisplayName"
                    switch about[index] {
                        
                    case "DisplayName":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/displayname").setValue(data)
                        
                    case "Gender":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/gender").setValue(data)
                        
                    case "Age":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/age").setValue(data)
                        
                    case "Phone":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/phone").setValue(data)
                        
                    //case "Email":
                        //DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/email").setValue(data)
                        
                    case "Website":
                        DataService.ds.REF_USER_PROFILES.child("\(user!.uid)/website").setValue(data)
                        
                    default:
                        print("dont update")
                    }//end switch
                }//end if
                
            }
            
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
