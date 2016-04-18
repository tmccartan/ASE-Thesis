//
//  LockedConversationVC.swift
//  Stegotweet
//
//  Created by Terry McCartan on 17/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import UIKit


class Thread {
    var name:String = "";
    var content: String = "";
    var image:String = "";
}


class LockedConversationVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var tweets = [Tweet]()
    var threads = [Thread]();
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Dummy Tweets for UI
        
        
        let thread1 = Thread()
        thread1.name = "John";
        thread1.content = "blah blah blah";
        thread1.image = "jakeTwit"
        let thread2 = Thread()
        thread2.name = "Sue";
        thread2.content = "blah blah blah";
        thread2.image = "jakeMedium"
        let thread3 = Thread()
        thread3.name = "Sue";
        thread3.content = "blah blah blah";
        thread3.image = "jakeMedium"
        let thread4 = Thread()
        thread4.name = "John";
        thread4.content = "blah blah blah";
        thread4.image = "jakeMedium"
        threads.append(thread1)
        threads.append(thread2)
        threads.append(thread3)
        threads.append(thread4)
        tableView.dataSource = self
        tableView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false

    }
    
    
    func tweetToThread(tweets: [Tweet]) -> [Thread] {
        
        return [Thread]();
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let conversation = threads[indexPath.row]
        if(conversation.name == "John"){
            let cell = tableView.dequeueReusableCellWithIdentifier("LeftConL", forIndexPath: indexPath) as! LeftLockedTVC
            cell.textContent.text = "Left - "+conversation.content
            cell.imageContent.image = UIImage(named: conversation.image)
            cell.profileImage.image = UIImage(named: "profile1")
            cell.profileImage.clipsToBounds = true
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("RightConL", forIndexPath: indexPath) as! RightLockedTVC
            cell.textContent.text =  "Right - "+conversation.content
            cell.imageContent.image = UIImage(named: conversation.image)
            cell.profileImage.image = UIImage(named: "profile2")
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("did select:      \(indexPath.row)  ")
    }
    
}