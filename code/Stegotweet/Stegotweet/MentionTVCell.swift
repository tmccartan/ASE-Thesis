//
//  MentionTVCell.swift
//  Stegotweet
//
//  Created by Terry McCartan on 16/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import UIKit

class MentionTVCell: UITableViewCell {
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var lblScreenName: UILabel!
    @IBOutlet weak var txtTweetContent: UITextView!
    
    var hashtagColor = UIColor.blueColor()
    var urlColor = UIColor.redColor()
    var userMentionsColor = UIColor.greenColor()
    
    var tweet: Tweet? {
        didSet {
            updateCell()
        }
    }
    
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
        
        lblScreenName?.text = "\(tweet!.user)"
        
        accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
    
    }
    
    
}
private extension NSMutableAttributedString {
    func changeKeywordsColor(keywords: [Tweet.IndexedKeyword], color: UIColor) {
        for keyword in keywords {
            addAttribute(NSForegroundColorAttributeName, value: color, range: keyword.nsrange)
        }
    }
}