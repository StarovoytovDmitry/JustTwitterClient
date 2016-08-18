//
//  Tweet.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 18.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

class Tweet {
    
    var tweetID: NSNumber!
    var screenname: NSString?
    var author: NSString?
    var authorProfilePicURL: NSURL?
    
    var urls: [NSDictionary]?
    var media: [NSDictionary]?
    
    var text: NSString?
    var timestamp: NSDate?
    var retweetsCount: Int = 0
    var favoritesCount: Int = 0
    
    var precedingTweetId: Int?
    var precedingTweet: Tweet?
    
    var favorited: Bool {
        didSet {
            if favorited {
                favoritesCount += 1
                /*TwitterClient.sharedInstance.favorite(["id": tweetID], favorite: true, completion: { (tweet, error) in
                    print("Favorited")
                })*/
            } else {
                favoritesCount -= 1
                /*TwitterClient.sharedInstance.favorite(["id": tweetID], favorite: false, completion: { (tweet, error) in
                    print("Unfavorited")
                })*/
            }
        }
    }
    
    var retweeted: Bool {
        didSet {
            if retweeted {
                retweetsCount += 1
                /*TwitterClient.sharedInstance.retweet(["id": tweetID], retweet: true, completion: { (tweet, error) in
                    print("Retweeted")
                })*/
            } else {
                retweetsCount -= 1
                /*TwitterClient.sharedInstance.retweet(["id": tweetID], retweet: false, completion: { (tweet, error) in
                    print("Unretweeted")
                })*/
            }
        }
    }
    
    init(dictionary: NSDictionary) {
        tweetID = dictionary["id"] as! NSNumber
        precedingTweetId = dictionary["in_reply_to_status_id"] as? Int
        
        urls = dictionary["entities"]?["urls"] as? [NSDictionary]
        media = dictionary["entities"]?["media"] as? [NSDictionary]
        
        screenname = dictionary["user"]!["screen_name"] as? String
        author = dictionary["user"]!["name"] as? String
        authorProfilePicURL = NSURL(string: (dictionary["user"]!["profile_image_url_https"] as! String).replace("normal.png", withString: "bigger.png"))!
        
        text = dictionary["text"] as? String
        
        retweetsCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favorited = (dictionary["favorited"] as? Bool) ?? false
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
    
    class func timeSince(date: NSDate) -> String {
        var unit = "s"
        var timeSince = abs(date.timeIntervalSinceNow as Double) // in seconds
        
        let calculateTime = intervalTime(unit, value: timeSince)
        
        while(calculateTime != true) {
            unit = "m"
            timeSince = round(timeSince / 60)
            if intervalTime(unit, value: timeSince) { break }
            
            unit = "h"
            timeSince = round(timeSince / 60)
            if intervalTime(unit, value: timeSince) { break }
            
            unit = "d"
            timeSince = round(timeSince / 24)
            if intervalTime(unit, value: timeSince) { break }
            
            unit = "w"
            timeSince = round(timeSince / 7)
            if intervalTime(unit, value: timeSince) { break }
            
            (unit, timeSince) = localizedDate(date); break
            
        }
        
        let value = Int(timeSince)
        return "\(value)\(unit)"
    }
    
    class func intervalTime(unit: String, value: Double) -> Bool {
        let value = Int(round(value))
        
        switch unit {
        case "s":
            return value < 60
        case "m":
            return value < 60
        case "h":
            return value < 24
        case "d":
            return value < 7
        case "w":
            return value < 4
        default:
            return true
        }
    }
    
    class func localizedDate(date: NSDate) -> (unit: String, timeSince: Double) {
        var unit = "/"
        let formatter = NSDateFormatter()
        formatter.dateFormat = "M"
        let timeSince = Double(formatter.stringFromDate(date))!
        formatter.dateFormat = "d/yy"
        unit += formatter.stringFromDate(date)
        return (unit, timeSince)
    }
    
    class func localizedTimestamp(date: NSDate) -> String {
        let (unit, timeSince) = localizedDate(date)
        let value = Int(timeSince)
        var l18n = "\(value)\(unit), "
        let formatter = NSDateFormatter()
        formatter.dateFormat = "h:mm a"
        l18n += formatter.stringFromDate(date)
        return l18n
    }  
}
