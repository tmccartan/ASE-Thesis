//
//  TweetsTVC.swift
//  TweeterTags
//
//  Created by Me on 17/01/2016.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit

class TweetsTVC: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Data Model
    
    var tweets = [[Tweet]]()
    var hashtagSearchText: String? = "#rising1916" {
        didSet {
            lastSuccessfulRequest = nil // search for new item
            hashtagSearchTextField?.text = hashtagSearchText
            tweets.removeAll()
            tableView.reloadData() // clear out the table view
            refresh()
        }
    }
    
    // MARK: - Storyboard
    
    private struct StoryBoard {
        static let CellReuseIdentifier = "TweetCell"
        static let MentionsTVCSegueIdentifier = "Show Mentions"

    }

    @IBOutlet weak var hashtagSearchTextField: UITextField! {
        didSet {
            hashtagSearchTextField.delegate = self
            hashtagSearchTextField.text = hashtagSearchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == hashtagSearchTextField {
            textField.resignFirstResponder()
            hashtagSearchText = textField.text
        }
        return true
    }

    // MARK: - Refreshing
    
    private var lastSuccessfulRequest: TwitterRequest?
    
    private var nextRequestToAttempt: TwitterRequest? {
        guard (lastSuccessfulRequest != nil) else {
            guard (hashtagSearchTextField != nil) else {
                return nil
            }
            RecentSearches().add(hashtagSearchText!)
            return TwitterRequest(search: hashtagSearchText!, count: 80)
        }
        return lastSuccessfulRequest!.requestForNewer
    }
    
    @IBAction private func refresh(sender: UIRefreshControl?) {
        guard let request = nextRequestToAttempt else {
            sender?.endRefreshing()
            return
        }
        request.fetchTweets { (newTweets) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if newTweets.count > 0 {
                    self.lastSuccessfulRequest = request
                    self.tweets.insert(newTweets, atIndex: 0)
                    self.tableView.reloadData()
                }
                sender?.endRefreshing()
            }
        }
    }
    
    func refresh() {
        refreshControl?.beginRefreshing()
        refresh(refreshControl)
    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.CellReuseIdentifier, forIndexPath: indexPath) as! TweetTVCell
        
        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]

        return cell
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
        
        guard let identifier = segue.identifier where identifier == StoryBoard.MentionsTVCSegueIdentifier else {
            return
        }
        if let vc = segue.destinationViewController as? MentionsTVC, tweetCell = sender as? TweetTVCell {
            vc.tweet = tweetCell.tweet
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == StoryBoard.MentionsTVCSegueIdentifier {
            if let tweetCell = sender as? TweetTVCell {
                if tweetCell.tweet!.hashtags.count + tweetCell.tweet!.urls.count + tweetCell.tweet!.userMentions.count + tweetCell.tweet!.media.count == 0 {
                    return false
                }
            }
        }
        return true
    }
}
