//
//  RecentsTVC.swift
//  TweeterTags
//
//  Created by Me on 18/01/2016.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit


// MARK: - Class to represent recent searched items

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

class RecentsTVC: UITableViewController {
    
    // MARK: - Storyboard
    
    private struct Storyboard {
        static let CellReuseIdentifier = "RecentsCell"
        static let SegueIdentifier = "ShowRecentSearch"
    }
    
    // MARK: - VC Lifecycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearches().values.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = RecentSearches().values[indexPath.row]

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.SegueIdentifier {
            if let tweetsTVC = segue.destinationViewController as? TweetsTVC, cell = sender as? UITableViewCell {
                tweetsTVC.hashtagSearchText = cell.textLabel?.text
            }
        }
    }
}

