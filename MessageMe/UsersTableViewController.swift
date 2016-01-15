//
//  UsersTableViewController.swift
//  MessageMe
//
//  Created by Roman on 1/14/16.
//  Copyright © 2016 Roman Puzey. All rights reserved.
//

import UIKit
import Parse

class UsersTableViewController: UITableViewController
{

    var users = []

    @IBAction func logoutPressed(sender: AnyObject)
    {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) -> Void in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

    @IBAction func backPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func viewWillAppear(animated: Bool) {

        users = []

        let user = PFUser.currentUser()
        if user != nil {

            self.navigationItem.title = "\((user?.username)!)"

            let query = PFUser.query()
            query?.whereKey("username", notEqualTo: (user?.username)!)
            query?.orderByAscending("username")

            query?.findObjectsInBackgroundWithBlock({ (results: [PFObject]?, error: NSError?) -> Void in

                if error == nil
                {
                    self.users = results!
                    self.tableView.reloadData()
                }
            })
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return users.count > 0 ? 1 : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let strDate = dateFormatter.stringFromDate(users[indexPath.row].createdAt!!)

        cell.textLabel?.text = users[indexPath.row].username!!
        cell.detailTextLabel?.text = "Member Since \(strDate)"

        return cell
    }

    @IBAction func newMessagePressed(sender: AnyObject)
    {
        if self.tableView.indexPathForSelectedRow == nil
        {
            let alertController = UIAlertController(title: "Error", message: "Please make sure you select a user from the users list to send a message", preferredStyle: .Alert)

            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))

            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            self.performSegueWithIdentifier("newMessage", sender: self)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "newMessage"
        {
            let indexPath = self.tableView.indexPathForSelectedRow
            let toUser = self.tableView.cellForRowAtIndexPath(indexPath!)?.textLabel?.text!

            let controller: NewMessageViewController = segue.destinationViewController as! NewMessageViewController
            controller.toUser = toUser!
        }
    }
}
