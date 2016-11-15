//
//  NotificationsViewController.swift
//  iTime
//
//  Created by Димас on 6/11/16.
//  Copyright © 2016 Димас. All rights reserved.
// notificationCell

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var labelType: UILabel!
    
    @IBOutlet weak var labelTimeAgo: UILabel!
    
    @IBOutlet weak var labelDescription: UILabel!
    
}

class NotificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var buttonBack: UIButton!
    @IBAction func buttonBackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: - tableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("notificationCell", forIndexPath: indexPath) as! NotificationCell
        
        return cell
    }

    
}
