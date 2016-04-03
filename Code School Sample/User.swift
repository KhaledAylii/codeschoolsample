//
//  User.swift
//  Code School Sample
//
//  Created by Khaled Ali on 4/2/16.
//  Copyright © 2016 KhaledAli. All rights reserved.
//


import UIKit
import Firebase

struct User {
    
    // Constants
    let key: String!
    let email: String!
    let profileImageUrl: String!
    let username: String!
    let ref: Firebase!
    
    init(snapshot: FDataSnapshot) {
        key = snapshot.key
        email = snapshot.value["email"] as! String
        profileImageUrl = snapshot.value["profileImageUrl"] as! String
        username = snapshot.value["username"] as! String
        ref = snapshot.ref
    }
    
}
