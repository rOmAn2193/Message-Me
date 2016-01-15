//
//  ViewController.swift
//  MessageMe
//
//  Created by Roman on 1/13/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit
import Parse


class ViewController: UIViewController
{

    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!

    @IBAction func logInPressed(sender: AnyObject)
    {
        self.view.endEditing(true)

        progressIndicator.startAnimating()

        PFUser.logInWithUsernameInBackground(userName.text!, password: password.text!) { (user: PFUser?, error: NSError?) -> Void in

            if user != nil
            {
                self.progressIndicator.stopAnimating()
                self.performSegueWithIdentifier("showUsers", sender: self)
            }
            else
            {
                self.progressIndicator.stopAnimating()
                self.myAlert("Error", messageText: (error?.localizedDescription)!)
            }
        }
    }

    @IBAction func signUpPressed(sender: AnyObject)
    {
        self.view.endEditing(true)

        if userName.text != "" && password.text != ""
        {
            progressIndicator.startAnimating()

            let user = PFUser()
            user.username = userName.text
            user.password = password.text

            user.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in

                if error == nil
                {
                    self.progressIndicator.stopAnimating()
                    self.performSegueWithIdentifier("showUsers", sender: self)
                }
                else
                {
                    self.progressIndicator.stopAnimating()
                    self.myAlert("Error", messageText: (error?.localizedDescription)!)
                }

            })
        }
        else
        {
            myAlert("Error", messageText: "Please provide a usernname and password to sign up.")
        }

    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)
    {
        self.view.endEditing(true)
    }

    func myAlert(titleText: String, messageText: String)
    {
        let alertController = UIAlertController(title: titleText, message: messageText, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        userName.text = ""
        password.text = ""

        if PFUser.currentUser() != nil
        {
            self.performSegueWithIdentifier("showUsers", sender: self)
        }
    }


}

