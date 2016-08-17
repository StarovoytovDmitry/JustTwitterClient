//
//  TwitterClient.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 17.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL:  NSURL(string:"https://api.twitter.com"), consumerKey: "t7R95IgNVg1id8xunFn9xFUbJ", consumerSecret: "CJEbFSNTC9LxnTB2kAFQU89IbJMw1MqkH7Pq4hJIbaZiUpYg5v")
    var loginSuccess: (()->())?
    var loginFailure: ((NSError)->())?
    
    weak var delegate: TwitterLoginDelegate?
    
    //Getting request token to open auth link in Safari
    
    func login(success: ()->(), failyre: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failyre
        
        deauthorize()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "justtwitter://oauth"), scope: nil, success: { (requestToken) in
            print("Get Token!")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=" + requestToken.token)!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error) in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    //Get access token and save user
    func handleOpenUrl(url: NSURL) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        appDelegate.splashDelay = true
        print(appDelegate.splashDelay)
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)!
        
        //Getting access token
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            self.currentAccount({ (user: User) in
                //Calling setter and saving user 
                User.currentUser = user
                self.loginSuccess?()
                self.delegate?.continueLogin()
                }, failyre: { (error) in
                    self.loginFailure?(error)
            })
            self.loginSuccess?()
            
            }) { (error) in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    //Get the current account
    func currentAccount(success: (User) -> (), failyre: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, responce) in
            
            let userDictionary = responce as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
            }) { (task, error) in
                print("error: \(error.localizedDescription)")
                failyre(error)
        }
    }
    //Log Out
    func logOut() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification , object: nil)
    }
}
