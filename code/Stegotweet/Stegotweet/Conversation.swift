//
//  Converstation.swift
//  Stegotweet
//
//  Created by Terry McCartan on 09/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

//Struct to model what a conversation is stored as 

import Foundation

public struct Conversation {
    
    var name : String
    var user : String
    var created_at : NSDate
    var last_updated_at : NSDate
    var lines : [Line]
}
    