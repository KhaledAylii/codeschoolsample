//
//  HomeFeedTableViewController.swift
//  Code School Sample
//
//  Created by Khaled Ali on 4/1/16.
//  Copyright © 2016 KhaledAli. All rights reserved.
//

import UIKit
import Firebase

class HomeFeedTableViewController: UITableViewController {
    
    // Constants
    let ref = Firebase(url: "https://codeschoolsample.firebaseio.com/")
    
    // Variables
    var posts: [PostItem]!
    var selectedUsername: String!
    
    // Outlets
    

    
    // MARK: -UIView Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get posts from server
        let postsRef = self.ref.childByAppendingPath("posts")
        postsRef.observeEventType(.Value, withBlock: { snapshot in
            
            var newPosts = [PostItem]()
            
            for item in snapshot.children {
                
                let post = PostItem(snapshot: item as! FDataSnapshot)
                newPosts.append(post)
                
            }
            
            self.posts = newPosts
            self.tableView.reloadData()
        })
        
        
        // Make tableView rows have variable height based on content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        self.tableView.reloadData()
        
    }
    
    // MARK: -Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "moveToUserProfile") {
            
            let destVc = segue.destinationViewController as! ProfileViewController
            
            destVc.selectedUsername = self.selectedUsername
            
        }
        
    }

    
    // MARK: -UITableViewController delegate methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Check if posts exist
        if self.posts != nil {
            
            return self.posts.count
            
        } else {
            
            // No posts exist
            return 0
            
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostTableViewCell
        
        // Get post data
        let post = self.posts[indexPath.row]
        
        // Populate cell with post data
        cell.postedBy.setTitle(post.postedBy, forState: .Normal)
        cell.postContent.text = post.postContent
        
        // Set action for postedBy link
        cell.postedBy.tag = indexPath.row
        cell.postedBy.addTarget(self, action: "moveToUserProfile:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }


    // MARK: -Custom functions

    func moveToUserProfile(sender: UIButton) {
    
        // Pass username to profile view
        
        self.selectedUsername = self.posts[sender.tag].postedBy!
        
        self.performSegueWithIdentifier("moveToUserProfile", sender: nil)
    
    }
}
