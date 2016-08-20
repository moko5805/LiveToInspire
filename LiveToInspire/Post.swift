//
//  Post.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 8/5/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _likes: Int!
    private var _postDescription: String!
    private var _imageUrl: String?
    private var _username: String!
    private var _postKey: String!
    private var _PostRef: FIRDatabaseReference!
    
    var likes: Int {
        return _likes
    }
    
    var postDescription: String {
        return _postDescription
    }
    
    var imageUrl: String? {
        return _imageUrl
    }
    
    var username: String {
        return _username
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(description: String, username: String, imageUrl: String?) {
        self._postDescription = description
        self._username = username
        self._imageUrl = imageUrl
    }
    
    //when it comes to dowmloading/parsing data from firebase
    init(postKey: String, dictionary: Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let likes = dictionary["likes"] as? Int {
            self._likes = likes
        }
        
        if let desc = dictionary["caption"] as? String {
            self._postDescription = desc
        }
        
        if let imgUrl = dictionary["imageUrl"] as? String {
            self._imageUrl = imgUrl
        }
        
        self._PostRef = DataService.ds.REF_POSTS.child(self._postKey)
    }
        
    
    func adjustLikes(addLike: Bool) {
        
        if addLike {
            _likes = _likes + 1
        } else {
            _likes = _likes - 1
        }
        
        //we also need to update the firebase total number of likes for each post under Posts object of FIR
        //we first need to grab a reference to the current post
        
        _PostRef.child("likes").setValue(_likes)
    }
    
}
