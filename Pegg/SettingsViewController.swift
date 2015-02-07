//
//  SettingsViewController.swift
//  Pegg
//
//  Created by Henry Saniuk on 2/4/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

enum SettingsTableSection: Int {
    case AccountSettings
    case Other
    case ContactUs
}

class SettingsViewController: UITableViewController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = tableView.indexPathForSelectedRow()?.row
        if let section = SettingsTableSection(rawValue: indexPath.section) {
            switch section {
            case .AccountSettings:
                AuthenticationManager.invalidateToken()
                self.performSegueWithIdentifier("logout", sender: self)
            case .ContactUs:
                let email = "peggapp@csh.rit.edu"
                let url = NSURL(string: "mailto:\(email)")
                UIApplication.sharedApplication().openURL(url!)
            default: break
            }
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}

