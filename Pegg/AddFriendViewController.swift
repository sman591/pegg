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
    
    var friends = [Friend]()
    
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
                for (friendIndex: String, friend: JSON) in json {
                    self.friends.append(Friend(
                        username: friend["username"].stringValue,
                        first: friend["first"].stringValue,
                        last: friend["last"].stringValue
                    ))
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
        let friend = self.friends[indexPath.row]
        
        cell.nameLabel?.text = friend.fullName()
        cell.descriptionLabel?.text = friend.username
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        PeggAPI.addFriend(friends[indexPath.row].username,
            completion: { json in
                self.dismissViewControllerAnimated(true, completion: nil)
            }, failure: { json in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        )
    }
}
