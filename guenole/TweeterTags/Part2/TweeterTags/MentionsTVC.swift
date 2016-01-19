//
//  MentionsTVC.swift
//  TweeterTags
//
//  Created by Me on 17/01/2016.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit

class MentionsTVC: UITableViewController {

    // MARK - Data Model
    var mentions: [Mentions] = []

    struct Mentions: CustomStringConvertible
    {
        var title: String
        var data: [MentionItem]
        
        var description: String { return "\(title): \(data)" }
    }
    
    enum MentionItem: CustomStringConvertible
    {
        case Keyword(String)
        case Image(NSURL, Double)
        
        var description: String {
            switch self {
            case .Keyword(let keyword): return keyword
            case .Image(let url, _): return url.path!
            }
        }
    }

    var tweet: Tweet? {
        didSet {
            title = tweet?.user.screenName
            if let media = tweet?.media where media.count > 0 {
                mentions.append(Mentions(title: "Images", data: media.map { MentionItem.Image($0.url, $0.aspectRatio) }))
            }
            if let urls = tweet?.urls where urls.count > 0 {
                mentions.append(Mentions(title: "URLs", data: urls.map { MentionItem.Keyword($0.keyword) }))
            }
            if let hashtags = tweet?.hashtags where hashtags.count > 0 {
                mentions.append(Mentions(title: "Hashtags", data: hashtags.map { MentionItem.Keyword($0.keyword) }))
            }
            if let users = tweet?.userMentions where users.count > 0 {
                mentions.append(Mentions(title: "Users", data: users.map { MentionItem.Keyword($0.keyword) }))
            }
        }
    }

    // MARK: - Storyboard
    
    private struct Storyboard {
        static let KeywordCellReuseIdentifier = "KeywordCell"
        static let ImageCellReuseIdentifier = "ImageCell"
        static let SearchMentionSegueIdentifier = "ShowMention"
        static let ImageSegueIdentifier = "ShowImage"
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        
        switch mention {
        case .Keyword(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.KeywordCellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = keyword
            return cell
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCellReuseIdentifier, forIndexPath: indexPath) as! ImageTVCell
            cell.imageUrl = url
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let cell = sender as? UITableViewCell where identifier == Storyboard.SearchMentionSegueIdentifier {
            if let url = cell.textLabel?.text where url.hasPrefix("http") {
                UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                return false
            }
        }
        return true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SearchMentionSegueIdentifier {
            if let tweetsTVC = segue.destinationViewController as? TweetsTVC, let cell = sender as? UITableViewCell {
                tweetsTVC.hashtagSearchText = cell.textLabel?.text
            }
        } else if segue.identifier == Storyboard.ImageSegueIdentifier {
            if let imageVC = segue.destinationViewController as? ImageVC, let cell = sender as? ImageTVCell {
                imageVC.imageURL = cell.imageUrl
                imageVC.title = title
            }
        }
    }
}
