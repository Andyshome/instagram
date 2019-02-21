//
//  PostViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2019-01-09.
//  Copyright © 2019 邱子昂. All rights reserved.
//

import UIKit

var postuid : [String] = []


class PostViewController: UITableViewController {

    
    //载入数据到数组中
    
    struct post {
        var ava = AVFile.init()
        var username = String.init()
        var date = Date.init()
        var pic = AVFile.init()
        var puuid = String.init()
        var title = String.init()
    }
    
    var postArray : [post] = []
    
    
    func alert(message:String) {
        let alert = UIAlertController(title: "请注意", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPosts()
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        let backSwap = UISwipeGestureRecognizer.init(target: self, action: #selector(back(_:)))
        backSwap.direction = .right
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(backSwap)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 450
        addObserveNotification()
        
        
    }

    func addObserveNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.init("liked"), object: nil)
        
    }
    
    @objc func refresh() {
        self.tableView.reloadData()
    }
    
    
    func loadPosts() {
        let postQuery = AVQuery.init(className: "Posts")
        postQuery.whereKey("puuid", equalTo: postuid.last!)
        postQuery.findObjectsInBackground { (objects, error) in
            guard error == nil else {
                self.alert(message: "网络错误，请检查网络设置！")
                print(error?.localizedDescription)
                return
            }
            self.postArray.removeAll(keepingCapacity: false)
            for object in objects! {
                print("I am adding something")
                let avaImage = (object as AnyObject).value(forKey: "ava") as! AVFile
                let username = (object as AnyObject).value(forKey: "username") as! String
                let postDate = (object as AnyObject).createdAt
                let picImage = (object as AnyObject).value(forKey: "pic") as! AVFile
                let puuid = (object as AnyObject).value(forKey: "puuid") as! String
                let bio = (object as AnyObject).value(forKey: "title") as! String
                var newPost = post.init()
                newPost.ava = avaImage
                newPost.username = username
                newPost.date = postDate!!
                newPost.pic = picImage
                newPost.puuid = puuid
                newPost.title = bio
                
                self.postArray.append(newPost)
            }
            print(self.postArray[0].puuid)
            self.tableView.reloadData()
            
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postArray.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostViewControllerCell
        // Configure the cell...
        print(indexPath.row)
        cell.usernameButton.setTitle(postArray[indexPath.row].username,for: .normal)
        cell.puuidLabel.text = postArray[indexPath.row].puuid
        cell.puuidLabel.sizeToFit()
        cell.usernameButton.sizeToFit()
        cell.bioLabel.text = postArray[indexPath.row].title
        postArray[indexPath.row].ava.getDataInBackground { (data, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            cell.avaImg.image = UIImage.init(data: data!)
        }
        postArray[indexPath.row].pic.getDataInBackground { (data, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            cell.picImg.image = UIImage.init(data: data!)
        }
        
        let timePost = getTimeDifference(inputDate: &postArray[indexPath.row].date)
        
        print(timePost)
        var differenceDate : String = ""
        if timePost.second! <= 10 {
            differenceDate = "now"
        }
        
        if timePost.second! > 0 && timePost.minute! <= 0 {
            differenceDate = "\(timePost.second!) sec"
        }
        
        if timePost.minute! > 0 && timePost.hour! <= 0{
            differenceDate = "\(timePost.minute!) min"
        }
        
        if timePost.hour! > 0 && timePost.day! <= 0 {
            differenceDate = "\(timePost.hour!) hours"
        }
        
        if timePost.day! > 0 && timePost.weekOfMonth! <= 0 {
            differenceDate = "\(timePost.day!) day"
        }
        if timePost.weekOfMonth! > 0 {
            
            differenceDate = "\(timePost.weekOfMonth!) week"
        }
        cell.dateLabel.text = differenceDate
        
        let didLike = AVQuery.init(className: "Likes")
        didLike.whereKey("by", equalTo: AVUser.current()!.username)
        didLike.whereKey("to", equalTo: cell.puuidLabel.text!)
        didLike.countObjectsInBackground { (value, error) in
            guard error == nil else {
                self.alert(message: "网络错误，请检查网络设置！")
                return
            }
            if value == 0 {
                cell.likeButton.setTitle("unlike", for: .normal)
                cell.likeButton.setBackgroundImage(UIImage.init(named: "unlike.png"), for: .normal)
            } else {
                cell.likeButton.setTitle("like", for: .normal)
                cell.likeButton.setBackgroundImage(UIImage.init(named: "like.png"), for: .normal)
            }
        }
        
        let countLikes = AVQuery.init(className: "Likes")
        countLikes.whereKey("to", equalTo: cell.puuidLabel.text)
        countLikes.countObjectsInBackground { (value, error) in
            guard error == nil else {
                self.alert(message: "网络错误，请检查网络设置！")
                return
            }
            cell.likeLabel.text = "\(value)"
        }
        cell.usernameButton.layer.setValue(indexPath, forKey: "index")
        cell.commentButton.layer.setValue(indexPath, forKey: "index")
        cell.selectionStyle = .none
        return cell
    }
    
    @IBAction func usernameClicked(_ sender: UIButton) {
        let cellClicked = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableView.cellForRow(at: cellClicked) as! PostViewControllerCell
        if cell.usernameButton.titleLabel?.text == AVUser.current()?.username {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
            self.navigationController?.pushViewController(home!, animated: true)
        } else {
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "GuestViewController")
            self.navigationController?.pushViewController(guest!, animated: true)
        }
    }
    
    
    @IBAction func commentClicked(_ sender: UIButton) {
        let index = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableView.cellForRow(at: index) as! PostViewControllerCell
        var newComment = comment.init()
        newComment.commentowner = cell.usernameButton.titleLabel!.text!
        newComment.commentuid = cell.puuidLabel.text!
        
        commentArray.append(newComment)
        let myCommentViewController = self.storyboard?.instantiateViewController(withIdentifier: "CommentVC") as! CommentViewController
        self.navigationController?.pushViewController(myCommentViewController, animated: true)
    }
    
    
    
    func getTimeDifference( inputDate:inout Date) -> DateComponents {
        let now = Date.init()
        let components : Set<Calendar.Component> = [.second,.minute,.hour,.day,.weekOfMonth]
        let difference = Calendar.current.dateComponents(components, from: inputDate,to: now)
        return difference
    }
    

    @objc func back(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        if !postuid.isEmpty {
            postuid.removeLast()
        }
    }
    
    
}
