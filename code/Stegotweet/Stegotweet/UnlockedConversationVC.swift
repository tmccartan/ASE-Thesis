//
//  UnlockedConversationVC.swift
//  Stegotweet
//
//  Created by Terry McCartan on 17/04/2016.
//  Copyright © 2016 Terry McCartan. All rights reserved.
//

import Foundation
import UIKit

class UnlockedConversationVC : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var threads = [Thread]()
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thread1 = Thread()
        thread1.name = "John";
        thread1.content = "This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message";
        thread1.image = "jakeTwit"
        let thread2 = Thread()
        thread2.name = "Sue";
        thread2.content = "This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message";
        
        let thread3 = Thread()
        thread3.name = "Sue";
        thread3.content = "This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message";
      
        let thread4 = Thread()
        thread4.name = "John";
        thread4.content = "This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message,This is a secret message";
       
        threads.append(thread1)
        threads.append(thread2)
        threads.append(thread3)
        threads.append(thread4)
        tableview.dataSource = self
        tableview.delegate = self

        
        self.automaticallyAdjustsScrollViewInsets = false
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return threads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let conversation = threads[indexPath.row]
        if(conversation.name == "John"){
            let cell = tableView.dequeueReusableCellWithIdentifier("LeftCon", forIndexPath: indexPath) as! LeftUnlockedTVC
            cell.textContent.text = "Left - "+conversation.content
            cell.profileImage.image = UIImage(named: "profile1")
            cell.profileImage.clipsToBounds = true
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("RightCon", forIndexPath: indexPath) as! RightUnlockedTVC
            cell.textContent.text =  "Right - "+conversation.content
            cell.profileImage.image = UIImage(named: "profile2")
            return cell
        }

    }


}