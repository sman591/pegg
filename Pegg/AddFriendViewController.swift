//
//  AddFriendViewController.swift
//  Pegg
//
//  Created by Stuart Olivera on 2/7/15.
//  Copyright (c) 2015 Henry Saniuk, Stuart Olivera, Brandon Hudson. All rights reserved.
//

import UIKit
import SwiftyJSON

class AddFriendViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var friends: [String] = []
    var friendsUsernames: [String] = []
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var searchInput: UISearchBar!
    
    override func viewDidLoad() {
        searchInput.delegate = self
//        searchInput.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.utf16Count == 0 {
            return
        }
        PeggAPI.search(searchText,
            completion: { json in
                println(json)
                self.friends = []
                self.friendsUsernames = []
                for (friendIndex: String, friend: JSON) in json {
                    self.friends.append(friend["first"].stringValue + " " + friend["last"].stringValue)
                    self.friendsUsernames.append(friend["username"].stringValue)
                }
                self.tableView.reloadData()
            }, failure: { json in
            }
        )
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friends.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UserTableViewCell
        
        cell.nameLabel?.text = self.friends[indexPath.row]
        cell.descriptionLabel?.text = self.friendsUsernames[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        PeggAPI.addFriend(friendsUsernames[indexPath.row],
            completion: { json in
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: { json in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        )
    }
}
