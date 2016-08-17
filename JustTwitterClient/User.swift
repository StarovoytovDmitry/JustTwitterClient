//
//  User.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 17.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

class User {
    
    static var _currentUser: User?
    static let userDidLogoutNotification = "UserDidLogout"
    var dictionary: NSDictionary?
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUser") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                defaults.setObject(data, forKey: "currentUser")
            } else {
                defaults.setObject(nil, forKey: "currentUser")
            }
        }
    }
}
