//
//  HomeVC.swift
//  
//
//  Created by 邱子昂 on 2018/9/13.
//

import UIKit


class HomeVC: UICollectionViewController {

    var refresher : UIRefreshControl!
    
    var page: Int = 12
    var puuidArray = [String].init()
    var picArray = [AVFile].init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = AVUser.current()?.username?.uppercased()
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        loadPosts()
        collectionView.addSubview(refresher)
        self.collectionView.alwaysBounceVertical = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      
        let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        header.fullNameTxt.text = AVUser.current()?.object(forKey: "fullname") as? String
        header.webTxt.text = AVUser.current()?.object(forKey: "web") as? String
        header.webTxt.sizeToFit()
        header.bioTxt.text = AVUser.current()?.object(forKey: "bio") as? String
        header.bioTxt.sizeToFit()
        let avaQuery = AVUser.current()?.object(forKey: "ava") as! AVFile
        avaQuery.getDataInBackground { (data:Data?, error:Error?) in
            if data == nil {
                print(error?.localizedDescription)
            } else {
                header.avaImg.image = UIImage.init(data: data!)
            }
        }
        
        
        
        
        
        
        let currentUser : AVUser = AVUser.current()!
        
        
        
        
        
        
        
        
        
        let postsQuery = AVQuery.init(className: "Posts")
        postsQuery.whereKey("username", equalTo: currentUser.username)
        postsQuery.countObjectsInBackground { (count, error) in
            if error == nil {
                header.posts.text = String(count)
            } else {
                print(error?.localizedDescription)
            }
        }
        
        let postsTap = UITapGestureRecognizer.init(target: self, action: #selector(postsTap(_:)))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        
        
        
        let followersQuery = AVQuery.init(className: "_Follower")
        followersQuery.whereKey("user", equalTo: currentUser)
        followersQuery.countObjectsInBackground { (count, error) in
            if error == nil {
                header.followers.text = String(count)
            } else {
                print(error?.localizedDescription)
            }
        }
        let followersTap = UITapGestureRecognizer.init(target: self, action: #selector(FollowersTap(_:)))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        
        
        
        
        let followeesQuery = AVQuery.init(className: "_Followee")
        followeesQuery.whereKey("user", equalTo: currentUser)
        followeesQuery.countObjectsInBackground { (count, error) in
            if error == nil {
                header.followings.text = String(count)
                print("I am trying to get some one followee")
            } else {
                print(error?.localizedDescription)
            }
        }
        let followeeTap = UITapGestureRecognizer.init(target: self, action: #selector(FolloweeTap(_:)))
        followeeTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followeeTap)
        
        
        
        
        
        
        
        
        
        return header
    }
    
    
    
    
    
    @objc func refresh() {
        collectionView?.reloadData()
        refresher.endRefreshing()
    }
    
    
    @objc func postsTap(_ recognizer:UITapGestureRecognizer) {
        if !picArray.isEmpty {
            let index = IndexPath.init(item: 0, section: 0)
            self.collectionView.scrollToItem(at: index, at: UICollectionView.ScrollPosition.top, animated: true)
        }
        
    }
    
    @objc func FollowersTap(_ recognizer:UITapGestureRecognizer) {
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
        followers.user = (AVUser.current()?.username)!
        followers.show = "关 注 者"
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    
    
    @objc func FolloweeTap(_ recognizer:UITapGestureRecognizer) {
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
        followings.user = (AVUser.current()?.username)!
        followings.show = "关 注"
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    func loadPosts() {
        let query = AVQuery.init(className: "Posts")
        query.whereKey("username", equalTo: AVUser.current()?.username)
        query.limit = page
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.puuidArray.removeAll(keepingCapacity: false)
                self.puuidArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                    self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                }
                self.collectionView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
 

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
        picArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.picImg.image = UIImage(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        return cell
    }
    
    
    
  

}
