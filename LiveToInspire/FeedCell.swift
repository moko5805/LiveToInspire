//
//  FeedCell.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 7/30/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    //we are storing the request since we are using cache, so we can cancel the rVequestb at any time
    //var request: Request?
    
    var likedPostRef: FIRDatabaseReference!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.userInteractionEnabled = true
        
    }
    
    override func drawRect(rect: CGRect) {
        //perfect circle
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        postImg.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        likedPostRef = DataService.ds.REF_USRE_CURRENT.child("likes").child(post.postKey)
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil {
            self.postImg.image = img
        } else {
            if let imgUrl = post.imageUrl {
                let ref = FIRStorage.storage().referenceForURL(imgUrl)
                ref.dataWithMaxSize(2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("unable to download data from firebase storage")
                    } else {
                        print("image downloaded from firebase storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.postImg.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imageUrl!)
                                print("downloaded image added to cache")
                            }
                        }
                      }
                })
            }

          }
        
        likedPostRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if (snapshot.value as? NSNull) != nil {
                //This means we have not liked this specific post with this specific post key
                self.likeImg.image = UIImage(named: "heart-empty")
            } else {
                self.likeImg.image = UIImage(named: "heart-full")
            }
        })
    }
    
    func likeTapped(sender: UITapGestureRecognizer){
        likedPostRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if (snapshot.value as? NSNull) != nil {
                //This means we have not liked this specific post with this specific post key
                self.likeImg.image = UIImage(named: "heart-full")
                self.post.adjustLikes(true)
                self.likedPostRef.setValue(true)
                
            } else {
                self.likeImg.image = UIImage(named: "heart-empty")
                self.post.adjustLikes(false)
                self.likedPostRef.removeValue()
            }
        })
        
        
    }

}















////we wana make sure there is image URL because user does not have to submit an image
//if post.imageUrl != nil {
//    
//    if img != nil {
//        //image from cache coming from FeedVC
//        self.postImg.image = img
//    } else {
//        //now we need to make our request to download image
//        
//        request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: { request, response, data, err in
//            
//            if err == nil {
//                let img = UIImage(data: data!)!
//                self.postImg.image = img
//                //we need to add it to the cache after downloading
//                FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
//            }
//            
//        })
//    }
//    
//} else {
//    self.postImg.hidden = true
//}
//
