//
//  ChatsTVC.swift
//  Stegotweet
//
//  Created by Terry McCartan on 04/02/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation

import UIKit

class ConversationVC :  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var conversations = [Conversation]()
    
    
    @IBOutlet weak var conversationTV: UITableView!
    
    private struct StoryBoard {
        static let CellReuseIdentifier = "ConversationTVCell"
        static let MentionsTVCSegueIdentifier = "Show"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // These would be loaded an stor
        
        let testConversation = Conversation(name: "Test Conversation 1", user: "Terry", created_at: NSDate(), last_updated_at: NSDate(), image :"profile1")
        let testConversation2 = Conversation(name: "Test Conversation 2", user: "Terry", created_at: NSDate(), last_updated_at: NSDate(),image :"profile2")
        let testConversation3 = Conversation(name: "Test Conversation 3", user: "Terry", created_at: NSDate(), last_updated_at: NSDate(),image :"profile3")
        conversations.removeAll()
        conversations.append(testConversation)
        conversations.append(testConversation2)
        conversations.append(testConversation3)
        
        conversationTV.dataSource = self
        conversationTV.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ConversationTVCell
        let conversation = conversations[indexPath.row]
        cell.name.text = conversation.name;
        cell.profileImage.image = UIImage(named: conversation.image)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select:      \(indexPath.row)  ")
    }
}


    

