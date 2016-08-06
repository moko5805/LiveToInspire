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
    var posts = [Post]()
    static var imageCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 366
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            self.posts = []
            //data coming in from firebase is in snapshot format and we still need to parse it out to something useable in our app for display purposes
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let Key = snap.key
                        let post = Post(postKey: Key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func  numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func  tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("FeedCell") as? FeedCell {
            
            cell.request?.cancel()
            
            var img : UIImage?
            
            //let get image from cache
            if let imgUrl = post.imageUrl {
                img = FeedVC.imageCache.objectForKey(imgUrl) as? UIImage
            }
            
            //passing the image from cache if it exists
            cell.configureCell(post, img: img)
            
            return cell
        } else {
            return FeedCell()
        }
        
        //        return tableView.dequeueReusableCellWithIdentifier("FeedCell") as! FeedCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        if post.imageUrl == nil {
            return 150
        } else {
            return tableView.estimatedRowHeight
        }
    }
    
    
    
    
    
 
    
    
    
    
    
    
//    @IBAction func signoutTapped(sender: AnyObject) {
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
//        print("user uid removed from the disk")
//        try! FIRAuth.auth()?.signOut()
//        performSegueWithIdentifier("goToSignInpage", sender: nil)
//    }
//    

}
