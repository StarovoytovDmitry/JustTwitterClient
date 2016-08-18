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
    
    var refreshControl: UIRefreshControl!
    var reloadedIndexPaths = [Int]()
    var lastTweetId: Int?
    
    var isMoreDataLoading = false
    //var loadingMoreView: InfinityScrollActivityView?
    
    var tweets: [Tweet]? {
        didSet {
            lastTweetId = tweets![tweets!.endIndex - 1].tweetID as Int
        }
    }
    
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
        
        //Set up pull to refresh loading
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeViewController.reloadData), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
    }
    
    func reloadData(append: Bool = false) {
        
        TwitterClient.sharedInstance.homeTimeline(lastTweetId, success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            
            if (append) {
                var cleaned = tweets
                if tweets.count > 0 {
                    cleaned.removeAtIndex(0)
                }
                
                if cleaned.count > 0 {
                    self.tweets?.appendContentsOf(cleaned)
                    self.isMoreDataLoading = false
                    //self.loadingMoreView?.stopAnimation()
                    self.tableView.reloadData()
                }
            } else {
                self.lastTweetId = nil
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading && tweets?.count > 0) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging {
                isMoreDataLoading = true
                reloadData(true)
            }
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
        cell.indexPath = indexPath
        cell.tweet = tweets![indexPath.row]
        cell.delegate = self
        return cell
    }
}

extension HomeViewController: UITableViewDataSource {
    
}

extension HomeViewController: TwitterTableViewDelegate {
    
    func reloadTableCellAtIndex(cell: UITableViewCell, indexPath: NSIndexPath) {
        if(reloadedIndexPaths.indexOf(indexPath.row) == nil) {
            reloadedIndexPaths.append(indexPath.row)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
        }
    }
}
