//
//  DataService.swift
//  LiveToInspire
//
//  Created by Mostafa S Taheri on 8/4/16.
//  Copyright © 2016 Mostafa S Taheri. All rights reserved.
//

import Foundation
import Firebase

//url to the root of database
let DB_BASE = FIRDatabase.database().reference()

class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USRES = DB_BASE.child("users")
    
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: FIRDatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USRES: FIRDatabaseReference {
        return _REF_USRES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USRES.child(uid).updateChildValues(userData)
    }
}

