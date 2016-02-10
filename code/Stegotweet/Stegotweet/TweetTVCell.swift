//
//  TweetTVCell.swift
//  Stegotweet
//
//  Created by Terry McCartan on 09/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import UIKit
class TweetTVCell: UITableViewCell {
    // MARK: - Data Model
    var tweet: Tweet? {
        didSet {
            updateCell()
        }
    }
    
    @IBOutlet weak var txtScreenName: UILabel!
    @IBOutlet weak var imgTweetPic: UIImageView!
    @IBOutlet weak var txtTweetContent: UILabel!
    @IBOutlet weak var imgMedia: UIImageView!
    @IBOutlet weak var txtDate: UILabel!
    // MARK - Part2.1
    var hashtagColor = UIColor.blueColor()
    var urlColor = UIColor.redColor()
    var userMentionsColor = UIColor.greenColor()
    
    func updateCell(){
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
        
        txtTweetContent?.attributedText = attributedText
        
        txtScreenName?.text = "\(tweet!.user)" // tweet.user.description
        
        if let profileImageURL = tweet!.user.profileImageURL {
            let imageData = NSData(contentsOfURL: profileImageURL)
            // blocks main thread!
            imgTweetPic?.image = UIImage(data: imageData!)
        }
        if let mediaImageURL = tweet!.media.first?.url {
            let imageData = NSData(contentsOfURL: mediaImageURL)
            // blocks main thread!
            imgMedia?.image = UIImage(data: imageData!)
        }
        
        
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(tweet!.created) > 24*60*60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        txtDate?.text = formatter.stringFromDate(tweet!.created)
        
        // show accessory if need be
        if tweet!.hashtags.count + tweet!.urls.count + tweet!.userMentions.count + tweet!.media.count > 0 {
       //     accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        } else {
       //     accessoryType = UITableViewCellAccessoryType.None
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