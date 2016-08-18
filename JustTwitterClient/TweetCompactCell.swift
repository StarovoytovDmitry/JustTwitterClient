//
//  TweetCompactCell.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 18.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

class TweetCompactCell: TweetCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func tweetSetConfigureSubviews() {
        super.tweetSetConfigureSubviews()
        
        retweetCountLabel.text = tweet.retweetsCount > 0 ? String(tweet.retweetsCount) : ""
        favoriteCountLabel.text = tweet.favoritesCount > 0 ? String(tweet.favoritesCount) : ""
        tweetAgeLabel.text = Tweet.timeSince(tweet.timestamp!)
    }
    
}
