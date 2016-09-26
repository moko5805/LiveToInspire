//  DataService.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 8/4/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.

import Foundation
import Firebase


//url to the root of database
let DB_BASE = FIRDatabase.database().reference()
let DB_STORAGE = FIRStorage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    //DB references
    private  var _REF_BASE = DB_BASE
    private  var _REF_POSTS = DB_BASE.child("posts")
    private  var _REF_USRES = DB_BASE.child("users")
    private  var _REF_COMMENTS = DB_BASE.child("comments")
    private  var _REF_USER_PROFILES = DB_BASE.child("user profiles")
    
    //storage references
    private  var _REF_POST_IMAGES = DB_STORAGE.child("post-pics")
    private  var _REF_PROFILE_IMAGES = DB_STORAGE.child("profile-pics")
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USRES: FIRDatabaseReference {
        return _REF_USRES
    }
    
    var REF_COMMENTS: FIRDatabaseReference {
        return _REF_COMMENTS
    }
    
    var REF_USER_PROFILES: FIRDatabaseReference {
        return _REF_USER_PROFILES
    }
    
    var REF_USRE_CURRENT: FIRDatabaseReference {
        //user ID value for the currenly logged in user
        //let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = FIRAuth.auth()?.currentUser
        let currentUser = REF_USRES.child(user!.uid)
        
        return currentUser
    }
    
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    var REF_PROFILE_IMAGES: FIRStorageReference {
        return _REF_PROFILE_IMAGES
    }
    
    //this is where you write a newly singed up user to your databse/firebase
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USRES.child(uid).updateChildValues(userData)
    }
    
    func createFirebaseUserProfile(uid: String, userData: Dictionary<String, String>) {
        REF_USER_PROFILES.child(uid).updateChildValues(userData)
    }
    
    func returnCurrentUsername() -> String {
        
        let user = FIRAuth.auth()?.currentUser
        let userName = user!.displayName
        
        return userName!
    }
    
    
}

