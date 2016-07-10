//
//  TwitterTableViewController.swift
//  Smashtag
//
//  Created by devinxu on 6/10/16.
//  Copyright © 2016 devinxu. All rights reserved.
//

import UIKit

class TwitterTableViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    var searchText: String? = "#stanford" {
        didSet {
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
        }
    }
    
    
    var tweets = [[Tweet]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    var lastSuccessfulRequest: TwitterRequest?
    
    var nextRequestToAttempt: TwitterRequest? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return TwitterRequest(search: searchText!, count: 100)
            }else{
                return nil
            }
        }else{
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    func refresh() {
        if refreshControl != nil {
            refreshControl!.beginRefreshing()
        }
        refersh(refreshControl)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweets[section].count
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as! TwitterTableViewCell

        // Configure the cell...
        //let tweet = tweets[indexPath.section][indexPath.row]
        cell.tweet = tweets[indexPath.section][indexPath.row]
//        cell.textLabel?.text = cell.tweet.text
//        cell.detailTextLabel?.text = tweet.user.name

        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if searchTextField == textField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        
        return true
    }

    @IBAction func refersh(sender: UIRefreshControl?) {
        if searchText != nil {
            if let request = nextRequestToAttempt {
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if newTweets.count > 0 {
                            self.lastSuccessfulRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        }
                    }
                }
            }
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailImage" {
            let tdtvc = segue.destinationViewController as! TwitterDetailTableViewController
            if let cell = sender as? TwitterTableViewCell {
                tdtvc.tweet = cell.tweet
            }
        }
    }
}
