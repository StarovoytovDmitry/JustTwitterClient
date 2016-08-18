//
//  TwitterTableViewDelegate.swift
//  JustTwitterClient
//
//  Created by Дмитрий on 18.08.16.
//  Copyright © 2016 Dmitry. All rights reserved.
//

import UIKit

protocol TwitterTableViewDelegate: UITableViewDelegate {
    func reloadTableCellAtIndex(cell: UITableViewCell, indexPath: NSIndexPath)
    //func openProfile(userScreenname: NSString)
    //func openCompose(viewController: UIViewController)
}
