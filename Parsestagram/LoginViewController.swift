//
//  LoginViewController.swift
//  Parsestagram
//
//  Created by Daniela Gonzalez on 6/20/16.
//  Copyright © 2016 Daniela Gonzalez. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?)  -> Void in
            if (user != nil) {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
        }
    }
    
    @IBAction func register(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            } else {
                print(error?.localizedDescription)
            }
            
        }
    }
}

