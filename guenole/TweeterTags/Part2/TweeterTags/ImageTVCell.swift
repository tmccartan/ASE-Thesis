//
//  ImageTVCell.swift
//  TweeterTags
//
//  Created by Me on 17/01/2016.
//  Copyright © 2016 Me. All rights reserved.
//

import UIKit

class ImageTVCell: UITableViewCell {

    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageUrl: NSURL? { didSet { updateUI() } }
    
    func updateUI() {
        tweetImage?.image = nil
        if let url = imageUrl {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageUrl {
                        if imageData != nil {
                            self.tweetImage?.image = UIImage(data: imageData!)
                        } else {
                            self.tweetImage?.image = nil
                        }
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }

}
