//
//  MessageViewController.swift
//  MessageMe
//
//  Created by Roman on 1/14/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit
import Parse

class MessageViewController: UIViewController {

    var objectID: String = ""

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var sentAtLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!


    override func viewWillAppear(animated: Bool)
    {
        let query = PFQuery(className: "message")
        query.getObjectInBackgroundWithId(objectID) { (message: PFObject?, error: NSError?) -> Void in

            if error == nil
            {
                let messageDate = message?.valueForKey("createdAt") as? NSDate

                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss"

                let strDate = dateFormatter.stringFromDate(messageDate!)

                self.fromLabel.text = message?.valueForKey("fromUser") as? String
                self.sentAtLabel.text = strDate
                self.messageLabel.text = message?.valueForKey("message") as? String
            }
        }
    }

    @IBAction func trashPressed(sender: AnyObject)
    {
        let alertDelete = UIAlertController(title: "Delete", message: "Are you sure you want to delete this message", preferredStyle: .Alert)

        alertDelete.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (alertAction: UIAlertAction) -> Void in

            let query = PFQuery(className: "message")
            query.getObjectInBackgroundWithId(self.objectID, block: { (message: PFObject?, error: NSError?) -> Void in
                if error == nil
                {
                    message!.deleteInBackground()
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
        }))

        alertDelete.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))

        self.presentViewController(alertDelete, animated: true, completion: nil)
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
}
