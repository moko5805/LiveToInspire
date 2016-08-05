//
//  FeedVC.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 7/30/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func  numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        return tableView.dequeueReusableCellWithIdentifier("FeedCell") as! FeedCell
    }
    
    
    
    
    
    
    
//    @IBAction func signoutTapped(sender: AnyObject) {
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
//        print("user uid removed from the disk")
//        try! FIRAuth.auth()?.signOut()
//        performSegueWithIdentifier("goToSignInpage", sender: nil)
//    }
//    

}
