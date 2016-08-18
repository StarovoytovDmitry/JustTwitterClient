//
//  HomeViewController.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 18.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .Default
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150.0
        /*
        tableView.delegate = self
        tableView.dataSource = self
        */
        reloadData()
    }
    
    func reloadData() {
        TwitterClient.sharedInstance.homeTimeline({ (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            }) { (error) in
                print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets == nil {
            return 0
        } else {
            return tweets!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeCell", forIndexPath: indexPath) as! TweetCompactCell
        cell.tweet = tweets![indexPath.row]
        return cell
    }
}

extension HomeViewController: UITableViewDataSource {
    
}
