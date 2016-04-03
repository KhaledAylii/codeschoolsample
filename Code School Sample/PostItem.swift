//
//  PostItem.swift
//  Code School Sample
//
//  Created by Khaled Ali on 4/1/16.
//  Copyright © 2016 KhaledAli. All rights reserved.
//

import UIKit
import Firebase

struct PostItem {
    
    var postedBy: String!
    var postContent: String!
    
    init(snapshot: FDataSnapshot) {
        
        postedBy = snapshot.value["postedBy"] as! String
        postContent = snapshot.value["postContent"] as! String
        
    }
    
}
