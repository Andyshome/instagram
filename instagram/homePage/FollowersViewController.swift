//
//  FollowersViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2018/11/13.
//  Copyright © 2018 邱子昂. All rights reserved.
//

import UIKit

class FollowersViewController: UITableViewController {

    
    var show : String = String.init()
    var user = AVUser.init()
    var followerArray = [AVUser]()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = show
        
        
        if show == "关 注 者" {
            loadFollowers()
        } else {
            loadFollowings()
        }
        
        
    }
    
    
    func loadFollowers() {
        user.getFollowers({ (followers, error) in
            if error == nil && followers != nil {
                self.followerArray = followers! as! [AVUser]
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        })
    }
    
    
    func loadFollowings() {
        user.getFollowees({ (followings, error) in
            if error == nil && followings != nil {
                self.followerArray = followings! as! [AVUser]
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        })
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return followerArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! FollowersCell
        cell.usernameLable.text = followerArray[indexPath.row].username
        let ava = followerArray[indexPath.row].object(forKey: "ava") as! AVFile
        ava.getDataInBackground { (data, error) in
            if error == nil {
                cell.avaImg.image = UIImage.init(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        let query = followerArray[indexPath.row].followeeQuery()
        query.whereKey("user", equalTo: user)
        query.whereKey("followee", equalTo: followerArray[indexPath.row])
        query.countObjectsInBackground { (count, error) in
            if error == nil {
                if count == 0 {
                    cell.followBtn.setTitle("关 注", for: .normal)
                    cell.followBtn.backgroundColor = UIColor.lightGray
                } else {
                    cell.followBtn.setTitle("✅ 已关注", for: .normal)
                    cell.followBtn.backgroundColor = UIColor.green
                }
            }
        }
        if cell.usernameLable.text == user.username {
            cell.followBtn.isHidden = true
        }
        cell.user = followerArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FollowersCell
        if cell.usernameLable.text == AVUser.current()?.username {
            let home = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestArray.append(followerArray[indexPath.row])
            let guest = storyboard?.instantiateViewController(withIdentifier: "GuestViewController") as! GuestViewController
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
   
}
