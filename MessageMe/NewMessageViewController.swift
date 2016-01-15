//
//  NewMessageViewController.swift
//  MessageMe
//
//  Created by Roman on 1/14/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit
import Parse

class NewMessageViewController: UIViewController
{
    var toUser: String = ""

    @IBOutlet weak var messageTextView: UITextView!

    override func viewWillAppear(animated: Bool)
    {
        self.navigationItem.title = "To: \(toUser)"

        messageTextView.text = ""
        messageTextView.becomeFirstResponder()
    }

    @IBAction func sendPressed(sender: AnyObject)
    {
        if toUser != "" && messageTextView.text != ""
        {
            let newMessage = PFObject(className: "message")
            newMessage["fromUser"] = PFUser.currentUser()?.username!
            newMessage["toUser"] = toUser
            newMessage["message"] = messageTextView.text

            newMessage.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
                self.messageTextView.text = ""
                self.navigationController?.popViewControllerAnimated(true)
            })

        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

    }
}
