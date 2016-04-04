//
//  SelectUsernameViewController.swift
//  Code School Sample
//
//  Created by Khaled Ali on 4/2/16.
//  Copyright © 2016 KhaledAli. All rights reserved.
//

import UIKit
import Firebase

class SelectUsernameViewController: UIViewController {
    
    // Constants
    let ref = Firebase(url: "https://codeschoolsample.firebaseio.com/")
    
    // Variables
    var currentUser: User!
    
    // Outlets
    @IBOutlet weak var usernameInput: UITextField!
    
    // MARK: -Custom functions
    @IBAction func submit(sender: AnyObject) {
        
        let input = self.usernameInput.text!
        
        // Character set to check if username contains special characters
        let characterSet:NSCharacterSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789")
        
        // Check if username contains special characters
        if input.rangeOfCharacterFromSet(characterSet.invertedSet) != nil {
            
            let alert = UIAlertController(title: "Special characters found", message: "Sorry, the username can't contain any special characters. Only letters and numbers", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            
        }
            // Check if input field is empty
        else if input.characters.count == 0 {
            
            let alert = UIAlertController(title: "Input field is empty", message: "Please enter a username", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
            // Check if username is taken
        else {
            
            let userRef = self.ref.childByAppendingPath("users")
            
            // Recieve user info from server
            userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
                
                var taken = false
                
                for item in snapshot.children {
                    
                    let user = User(snapshot: item as! FDataSnapshot)
                    
                    if user.username == input {
                        
                        taken = true
                        
                        let alert = UIAlertController(title: "This username is already taken", message: "Please try a different one", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                }
                
                if taken == false {
                    
                    let authData = self.ref.authData
                    
                    self.ref.childByAppendingPath("users").childByAppendingPath("\(authData.uid)").childByAppendingPath("username").setValue(input)
                    self.performSegueWithIdentifier("loginToApp", sender: nil)
                    
                }
            })
        }

        
    }
    
}
