//
//  MentionsTVC.swift
//  Stegotweet
//
//  Created by Terry McCartan on 04/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import UIKit

class MentionsTVC :  UITableViewController, UITextFieldDelegate {
    
    var tweets = [[Tweet]]()
    
    var hashtagSearchText: String? = ""{
        didSet {
            lastSuccessfulRequest = nil // search for new item
            txtHashSearch?.text = hashtagSearchText
            tweets.removeAll()
            tableView.reloadData() // clear out the table view
            refresh()
        }
    }
    
    @IBOutlet weak var txtHashSearch: UITextField!{
        didSet {
                txtHashSearch.delegate = self
                txtHashSearch.text = hashtagSearchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == txtHashSearch {
            textField.resignFirstResponder()
            hashtagSearchText = textField.text
        }
        return true
    }

    // MARK: - Refreshing
    
    private var lastSuccessfulRequest: TwitterRequest?
    
    private var nextRequestToAttempt: TwitterRequest? {
        guard (lastSuccessfulRequest != nil) else {
            guard (hashtagSearchText != nil) else {
                return nil
            }
            RecentSearches().add(hashtagSearchText!)
            return TwitterRequest(search: "#" + hashtagSearchText! + "&@Paul_OConnell" + "&filter:images", count: 80)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("MentionCell", forIndexPath: indexPath) as! MentionTVCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
       return false
    }

}

class RecentSearches {
    
    private struct Constants {
        static let ValuesKey = "RecentSearches.Values"
        static let NumberOfSearches = 100
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var values: [String] {
        get { return defaults.objectForKey(Constants.ValuesKey) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: Constants.ValuesKey) }
    }
    
    func add(search: String) {
        var currentSearches = values
        if let index = currentSearches.indexOf(search) {
            currentSearches.removeAtIndex(index)
        }
        currentSearches.insert(search, atIndex: 0)
        while currentSearches.count > Constants.NumberOfSearches {
            currentSearches.removeLast()
        }
        values = currentSearches
    }
}
