//
//  ViewController.swift
//  Code School Sample
//
//  Created by Khaled Ali on 4/1/16.
//  Copyright © 2016 KhaledAli. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    // Constants
    let ref = Firebase(url: "https://codeschoolsample.firebaseio.com/")
    
    // Variables
    var isSigningUp = false
    var currentUser: User!
    
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var changeDescription: UILabel!
    
    // MARK: -UIView Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let authData = ref.authData
        
        // Check if user is already logged in
        if authData != nil {
            
            checkIfUsernameExists(authData)
            
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: -Custom functions
    
    func checkIfUsernameExists(authData: FAuthData!) {
        
        let userRef = self.ref.childByAppendingPath("users").childByAppendingPath("\(authData.uid)")
        userRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
            
            self.currentUser = User(snapshot: snapshot as FDataSnapshot)
            
            if self.currentUser.username == "" {
                
                self.performSegueWithIdentifier("selectUsername", sender: nil)
                
            } else {
                
                self.performSegueWithIdentifier("loginToApp", sender: nil)
                
            }
            
        })

        
    }
    
    @IBAction func submit(sender: AnyObject) {
        
        // Function for displaying errors in authentication
        func displayErrorAlert(actionName: String, error: NSError) {
            
            // Clear password field
            self.passwordTextField.text = ""
            
            // Show alert
            let alert = UIAlertController(title: "There was an error \(actionName)", message: "\(error)", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

        // Check if user is logging in or signing up
        if isSigningUp {
            
            ref.createUser(emailTextField.text, password: passwordTextField.text,
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        
                        // There was an error creating the account
                        displayErrorAlert("signing you up", error: error)
                        
                    } else {
                        
                        let newUser = [
                        
                            "email": self.emailTextField.text!,
                            "profileImageUrl": "",
                            "username": ""
                            
                        ]
                        
                        let uid = result["uid"] as? String
                        
                        self.ref.childByAppendingPath("users").childByAppendingPath("\(uid!)").setValue(newUser)
                        
                        // We are now signed up
                        print("Successfully created user account with uid: \(uid)")
                        self.performSegueWithIdentifier("selectUsername", sender: self)
                        
                    }
            })
            
            
        } else {
            
            ref.authUser(emailTextField.text, password: passwordTextField.text,
                withCompletionBlock: { error, authData in
                    if error != nil {
                    
                        // There was an error logging in to this account
                        displayErrorAlert("logging you in", error: error)
                        
                    } else {
                        
                        // We are now logged in
                        let uid = authData.uid
                        print("Successfully logged in as user account with uid: \(uid)")
                        self.checkIfUsernameExists(authData)
                        
                    }
            })
            
        }
        
    }
    
    @IBAction func changeAction(sender: AnyObject) {
        
        // Switches between signing up and logging in
        
        if isSigningUp {
            
            isSigningUp = false
            self.submitButton.setTitle("Login", forState: .Normal)
            self.changeButton.setTitle("Sign Up", forState: .Normal)
            self.changeDescription.text = "Not a member?"
            
        } else {
    
            isSigningUp = true
            self.changeButton.setTitle("Login", forState: .Normal)
            self.submitButton.setTitle("Sign Up", forState: .Normal)
            self.changeDescription.text = "Already a member?"
            
        }
        
    }
    

}

