//
//  MessagesTableViewController.swift
//  MessageMe
//
//  Created by Roman on 1/14/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit
import Parse

class MessagesTableViewController: UITableViewController
{
    var messages = []

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool)
    {

        messages = []

        let query = PFQuery(className: "message")
        query.whereKey("toUser", equalTo: (PFUser.currentUser()?.username)!)
        query.orderByAscending("createdAt")


        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in

            if error == nil
            {
                self.messages = results!
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return messages.count > 0 ? 1 : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let messageDate = messages[indexPath.row].valueForKey("createdAt") as? NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy hh:mm:ss"
        let strDate = dateFormatter.stringFromDate(messageDate!)

        let message: String = messages[indexPath.row].valueForKey("message") as! String

        let fromUser: String = messages[indexPath.row].valueForKey("fromUser") as! String

        cell.textLabel?.text = message
        cell.detailTextLabel?.text = "From \(fromUser) : \(strDate)"
        
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showMessage"
        {
            let indexPath = self.tableView.indexPathForSelectedRow!

            let controller: MessageViewController = segue.destinationViewController as! MessageViewController
            controller.objectID = messages[indexPath.row].valueForKey("objectId") as! String
        }
    }
}
