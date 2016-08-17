//
//  LoginViewController.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 17.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logoVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoMovedToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightOriginalConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightSmallerConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var buttonContainerView: UIView!
    
    @IBAction func onLoginButton() {
        TwitterClient.sharedInstance.login({
            print("Log In")
            self.dismissViewControllerAnimated(true, completion: {
                
            })
            }) { (error) in
                print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gradient
        let color1 = UIColor(red: 42.0/255.0, green: 163.0/255.0, blue: 239.0/255.0, alpha: 1.0)
        let color2 = UIColor(red: 88.0/255.0, green: 178.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        let color3 = UIColor(red: 141.0/255.0, green: 192.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        let color4 = UIColor(red: 224.0/255.0, green: 226.0/255.0, blue: 228.0/255.0, alpha: 1.0)
        
        let gradientColor: [CGColor] = [color1.CGColor, color2.CGColor, color3.CGColor, color4.CGColor]
        let gradientLocations: [Float] = [0.0, 0.25, 0.75, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColor
        gradientLayer.locations = gradientLocations
        
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        buttonContainerView.layer.cornerRadius = 7
        /*
        self.buttonContainerView.alpha = 0
        self.titleLabel.alpha = 0
        self.subTitleLabel.alpha = 0
        */
        
    }
    
    override func viewDidAppear(animated: Bool) {
        /* animated...
        super.viewDidAppear(animated)
        logoVerticalConstraint.active = false
        logoMovedToTopConstraint.active = true
        logoHeightOriginalConstraint.active = false
        logoHeightSmallerConstraint.active = true
        
        UIView.animateWithDuration(1.0) {
            
            self.view.layoutIfNeeded()
            
            self.buttonContainerView.alpha = 1
            self.titleLabel.alpha = 1
            self.subTitleLabel.alpha = 1
            
            self.buttonContainerView.frame = CGRectOffset(self.buttonContainerView.frame, 0, -20)
            self.titleLabel.frame = CGRectOffset(self.titleLabel.frame, 0, -20)
            self.subTitleLabel.frame = CGRectOffset(self.subTitleLabel.frame, 0, -20)
            
        }
        */
    }
    
}
