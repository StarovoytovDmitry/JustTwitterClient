//
//  HomeViewController.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 18.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBAction func logOut() {
        TwitterClient.sharedInstance.logOut()
    }
    
}
