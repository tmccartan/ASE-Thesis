//
//  ConversationTVCell.swift
//  Stegotweet
//
//  Created by Terry McCartan on 09/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import UIKit

class ConversationTVCell : UITableViewCell {
    
    var conversationModel: Conversation? {
        didSet {
            //do init logic
            updateCell()
        }
    }
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    private func updateCell() {
        //name.text = conversationModel!.name
    }
}