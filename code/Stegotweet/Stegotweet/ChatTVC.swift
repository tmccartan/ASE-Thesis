//
//  ChatVC.swift
//  Stegotweet
//
//  Created by Terry McCartan on 04/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import UIKit

class ChatTVC :  UITableViewController {
    
    let hashtag: String = "#ThanksPaulie"
    let mention: String = "&@Paul_OConnell"
    // need to add mention as well
    var tweets = [[Tweet]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            let request = TwitterRequest(search: hashtag + mention, count: 80)
            request.fetchTweets { (newTweets) -> Void in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                print(newTweets)
                if newTweets.count > 0 {
                    
                    self.tweets.insert(newTweets, atIndex: 0)
                    self.tableView.reloadData()
                }
            }
        }
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetTVCell
        
        // Configure the cell...
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell

    }
    
    
}
