//  FeedVC.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 7/30/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postField: MaterialTextField!
    @IBOutlet weak var imageSelectorImage: UIImageView!
    
    var imageSelected = false
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    
    static var imageCache = NSCache()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 366
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observeEventType(.Value, withBlock: { snapshot in
            self.posts = []
            //data coming in from firebase is in snapshot format and we still need to parse it out to something useable in our app for display purposes
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshots {
                    //print("SNAP: \(snap)")
                    
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        //see comment "IMPORTANT"
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
            
            if post.imageUrl != nil {
                
                let img = FeedVC.imageCache.objectForKey(post.imageUrl!) as? UIImage
                cell.configureCell(post, img: img)
                return cell
            } else {
                cell.configureCell(post)
                return cell
            }
            
            
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePicker.dismissViewControllerAnimated(true, completion: nil)
            imageSelectorImage.image = img
            imageSelected = true
        } else {
            print("a valid image wasn't selected")
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func makePost(sender: AnyObject) {
        
        guard let postDesc = postField.text where postDesc != "" else {
            print("post description must be entered")
            return
        }

        if let img = imageSelectorImage.image where imageSelected == true {
            if let imageData = UIImageJPEGRepresentation(img, 0.2) {
                
                let imgUid = NSUUID().UUIDString
                let metadata = FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imageData, metadata: metadata, completion: { (metadata, error) in
                    
                    if error != nil {
                        print("unable to upload image to firebase storage")
                    } else {
                        print("image was successfully uploaded to firebase storage")
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            self.postToFirebase(url)
                        }
                    }
                })
            }
        }
    }
    
    func postToFirebase(imgUrl: String) {
        let post: Dictionary<String, AnyObject> = [
        "caption": postField.text!,
        "imageUrl": imgUrl,
        "likes": 0
        ]
        
        //IMPORTANT: create a unique ID for your new post "Post Key", which can be retrieved later using "snap.key" and the value result can be assigned to var postKey of Post object and get the location to it for your reference
        let firNewPostRef = DataService.ds.REF_POSTS.childByAutoId()
        firNewPostRef.setValue(post)
        
        postField.text = ""
        imageSelected = false
        imageSelectorImage.image = UIImage(named: "camera")
        
        tableView.reloadData()
    }
    
//    @IBAction func signoutTapped(sender: AnyObject) {
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(KEY_UID)
//        print("user uid removed from the disk")
//        try! FIRAuth.auth()?.signOut()
//        performSegueWithIdentifier("goToSignInpage", sender: nil)
//    }
    
    @IBAction func didTapSignOut(sender: AnyObject) {
        
        //signs thee user out of the Firebase app
        try! FIRAuth.auth()!.signOut()
        
        //sing the user out of the Facebook app
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        performSegueWithIdentifier("goToSignInpage", sender: nil)
    }
    

}
