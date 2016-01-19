//
//  TweetTVCell.swift
//  TweeterTags
//
//  Created by Me on 17/01/2016.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit

class TweetTVCell: UITableViewCell {

    // MARK: - Data Model
    var tweet: Tweet? {
        didSet {
            updateCell()
        }
    }
    
    // MARK - Part2.1
    var hashtagColor = UIColor.blueColor()
    var urlColor = UIColor.redColor()
    var userMentionsColor = UIColor.greenColor()
    
    // MARK - Private
    
    @IBOutlet weak var tweetAvatarImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!

    
    private func updateCell() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetAvatarImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // clear cell if no tweet
        guard (tweet != nil) else {
            return
        }
  
        var text = tweet!.text
        for _ in tweet!.media {
            text += " 📷"
        }
        
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.changeKeywordsColor(tweet!.hashtags, color: hashtagColor)
        attributedText.changeKeywordsColor(tweet!.urls, color: urlColor)
        attributedText.changeKeywordsColor(tweet!.userMentions, color: userMentionsColor)
        attributedText.changeKeywordsColor(tweet!.mediaMentions, color: urlColor)
        
        tweetTextLabel?.attributedText = attributedText
        
        tweetScreenNameLabel?.text = "\(tweet!.user)" // tweet.user.description
        
        if let profileImageURL = tweet!.user.profileImageURL {
            let imageData = NSData(contentsOfURL: profileImageURL)
            // blocks main thread!
            tweetAvatarImageView?.image = UIImage(data: imageData!)
        }
        
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(tweet!.created) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        tweetCreatedLabel?.text = formatter.stringFromDate(tweet!.created)

        // show accessory if need be
        if tweet!.hashtags.count + tweet!.urls.count + tweet!.userMentions.count + tweet!.media.count > 0 {
            accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
            accessoryType = UITableViewCellAccessoryType.None
        }
    }
}

// MARK: - Extensions

private extension NSMutableAttributedString {
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}

