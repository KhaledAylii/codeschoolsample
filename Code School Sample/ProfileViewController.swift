//
//  ProfileViewController.swift
//  Code School Sample
//
//  Created by Khaled Ali on 4/2/16.
//  Copyright © 2016 KhaledAli. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Constants
    let ref = Firebase(url: "https://codeschoolsample.firebaseio.com")
    
    // Variables
    var selectedUsername: String!
    var selectedUser: User!
    var posts: [PostItem]!
    
    // Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    @IBAction func logout(sender: AnyObject) {
        
        ref.unauth()
        performSegueWithIdentifier("logoutFromApp", sender: nil)
        
    }
    override func viewDidLoad() {
        
        let authData = self.ref.authData
        
        // Get selected user's information
        let usersRef = self.ref.childByAppendingPath("users")
        usersRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            if self.selectedUsername == nil {
                
                usersRef.childByAppendingPath("\(authData.uid)").observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in

                    
                    self.selectedUser = User(snapshot: snapshot as FDataSnapshot!)
                    self.selectedUsername = self.selectedUser.username
                    self.navigationItem.title = "my profile"
                    // Display profile content and try to fetch profile picture from url if it exists
                    self.displayUserData()
                    self.getUserPosts()
                    
                })
                
            } else {
            
            
                for item in snapshot.children {
                
                    let user = User(snapshot: item as! FDataSnapshot)
                
                    // Find user profile
                    if user.username == self.selectedUsername {
                
                    
                        // Check if current user is viewing their own profile
                        if user.key == authData.uid {
                        
                            self.selectedUser = user
                            self.navigationItem.title = "my profile"
                        
                        } else {
                        
                        self.selectedUser = user
                        self.navigationItem.title = "\(user.username)'s profile"
                        self.navigationItem.rightBarButtonItem = nil
                            
                        }
                
                    }
                }
            
                // Display profile content and try to fetch profile picture from url if it exists
                self.displayUserData()
                self.getUserPosts()
            }
        })
    
        
        
        // Make tableView rows have variable height based on content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        
        }
    
    // MARK: -UITableViewController Delegate methods
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Check if posts exist
        if self.posts != nil {
            
            return self.posts.count
            
        } else {
            
            // No posts exist
            return 0
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostTableViewCell
        
        // Get post data
        let post = self.posts[indexPath.row]
        
        // Populate cell with post data
        cell.postedBy.setTitle(post.postedBy, forState: .Normal)
        cell.postContent.text = post.postContent
        
        return cell
    }
    
    
    // MARK: -Custom functions
    
    func getUserPosts() {
        
        
        // Get selected user's posts from server
        let postsRef = self.ref.childByAppendingPath("posts")
        postsRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            var newPosts = [PostItem]()
            
            for item in snapshot.children {
                
                let post = PostItem(snapshot: item as! FDataSnapshot)
                
                // Check if post is by selected user
                if post.postedBy == self.selectedUser.username {
                    
                    newPosts.append(post)
                    
                }
                
            }
            
            self.posts = newPosts
            self.tableView.reloadData()
            
        })
        
    }
    
    func displayUserData() {
        
        self.usernameLabel.text = self.selectedUser.username
        self.usernameLabel.sizeToFit()
        if self.selectedUser.profileImageUrl != "" {
            
            let url = NSURL(fileURLWithPath: self.selectedUser.profileImageUrl)
            let _ = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                
                if data != nil {
                    
                    self.profilePicture.image = UIImage(data: data!)
                    
                } else {
                    
                    // No image found (in a real app, we would set a default image)
                    
                }
                
            })
        }

    }
    
}
