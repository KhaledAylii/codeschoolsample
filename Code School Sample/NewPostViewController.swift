//
//  CreatePostViewController.swift
//  Code School Sample
//
//  Created by Khaled Ali on 4/1/16.
//  Copyright © 2016 KhaledAli. All rights reserved.
//

import UIKit
import Firebase

class NewPostViewController: UIViewController {
    
    // Constants
    let ref = Firebase(url: "https://codeschoolsample.firebaseio.com")
    
    // Variables
    var tooManyCharacters = false
    var currentUser: User!
    
    // Outlets
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var characterCount: UILabel!
    
    // MARK: -UIView Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authData = ref.authData
        let currentUserRef = ref.childByAppendingPath("users").childByAppendingPath("\(authData.uid)")
        currentUserRef.observeSingleEventOfType(.Value) { (snapshot) -> Void in
            
            self.currentUser = User(snapshot: snapshot as FDataSnapshot!)
            
        }
        
        inputTextView.textColor = UIColor.lightGrayColor()
        inputTextView.text = "Post something..."
        
        
    }
    override func viewDidLayoutSubviews() {
        
        inputTextView.setContentOffset(CGPointZero, animated: false)
        
    }
    
    // MARK: -Custom Functions
    
    @IBAction func submit(sender: AnyObject) {
        
        if tooManyCharacters {
            
            // Display alert: too many characters
            
        } else if inputTextView.text == "" || inputTextView.textColor == UIColor.lightGrayColor() {
            
            // Display alert: field is empty
            
        } else {
        
        let post = [
        
            "postedBy": currentUser.username as NSString as String,
            "postContent": inputTextView.text as NSString as String
            
        ]
            
        let postRef = ref.childByAppendingPath("posts").childByAutoId()
        postRef.setValue(post)
            
        self.navigationController?.popToRootViewControllerAnimated(true)
            
        }
        
    }
    
    // MARK: -UITextView Delegate methods
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        // Remove placeholder text
        if inputTextView.textColor == UIColor.lightGrayColor() {
            
            inputTextView.text = ""
            inputTextView.textColor = UIColor.blackColor()
            
        }
    }
    
    func textViewDidChange(textView: UITextView)
    {
     
        // Display remaining characters
        let characters = textView.text.characters.count
        let charactersRemaining = 140 - characters
        
        if charactersRemaining < 0 {
            
            // Over allowed characters
            characterCount.textColor = UIColor.redColor()
            characterCount.text = "\(charactersRemaining)"
            self.tooManyCharacters = true
        
        } else {
            
            characterCount.textColor = UIColor.blackColor()
            characterCount.text = "\(charactersRemaining)"
            self.tooManyCharacters = false
            
        }
        
    }
    
}
