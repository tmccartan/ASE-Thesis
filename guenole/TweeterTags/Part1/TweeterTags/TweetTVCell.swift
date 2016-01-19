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
        
        tweetTextLabel?.text = tweet!.text
        if tweetTextLabel?.text != nil  {
            for _ in tweet!.media {
                tweetTextLabel.text! += " 📷"
            }
        }
        
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
    }

    
}
