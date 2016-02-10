//
//  ChatsTVC.swift
//  Stegotweet
//
//  Created by Terry McCartan on 04/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation

import UIKit

class ThreadsTVC :  UITableViewController {
    
    var conversations = [Conversation]()
    
    private struct StoryBoard {
        static let CellReuseIdentifier = "ConversationTVCell"
        static let MentionsTVCSegueIdentifier = "Show"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let testConversation = Conversation(name: "Test Conversation 1", user: "Terry", created_at: NSDate(), last_updated_at: NSDate(), lines: [])
        let testConversation2 = Conversation(name: "Test Conversation 2", user: "Terry", created_at: NSDate(), last_updated_at: NSDate(), lines: [])
        let testConversation3 = Conversation(name: "Test Conversation 3", user: "Terry", created_at: NSDate(), last_updated_at: NSDate(), lines: [])
        conversations.removeAll()
        conversations.append(testConversation)
        conversations.append(testConversation2)
        conversations.append(testConversation3)
        print(conversations.capacity)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(StoryBoard.CellReuseIdentifier, forIndexPath: indexPath) as! ConversationTVCell
        
        // Configure the cell...
        cell.conversationModel = conversations[indexPath.row]
        return cell
    }

}


    

