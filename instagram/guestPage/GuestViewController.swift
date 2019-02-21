//
//  GuestViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2018/11/13.
//  Copyright © 2018 邱子昂. All rights reserved.
//

import UIKit

var guestArray = [AVUser]()
class GuestViewController: UICollectionViewController {
    
    var show = String()
    var user = String()
    
    var puuidArray = [String]()
    var picArray = [AVFile]()
    var refresher : UIRefreshControl!
    var page : Int = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = UIColor.white
        self.navigationItem.title = guestArray.last?.username
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        navigationItem.leftBarButtonItem = backBtn
        let backSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(back(_:)))
        backSwipe.direction = .right
        self.view.addGestureRecognizer(backSwipe)
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.addSubview(refresher)
        loadPosts()
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = self.collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! HeaderView
        let infoQuery = AVQuery.init(className: "_User")
        infoQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                guard let objects = objects, objects.count > 0 else {
                    return
                }
                
                for object in objects {
                    header.fullNameTxt.text = ((object as AnyObject).object(forKey: "fullname") as? String)?.uppercased()
                    header.bioTxt.text = ((object as AnyObject).object(forKey: "bio") as? String)
                    header.bioTxt.sizeToFit()
                    header.webTxt.text = ((object as AnyObject).object(forKey: "web") as? String)
                    header.webTxt.sizeToFit()
                    
                    let avaFile = (object as AnyObject).object(forKey: "ava") as? AVFile
                    avaFile?.getDataInBackground({ (data, error) in
                        if error == nil {
                            header.avaImg.image = UIImage.init(data: data!)
                        } else {
                            print(error?.localizedDescription)
                        }
                    })
                }
            }   else {
                print(error?.localizedDescription)
            }
        }
        
        
        
        
        let currentUser : AVUser = AVUser.current()!
        
        
        
        let followeeQuery = AVUser.current()?.followeeQuery()
        followeeQuery?.whereKey("user", equalTo: AVUser.current())
        followeeQuery?.whereKey("followee", equalTo: guestArray.last)
        followeeQuery?.countObjectsInBackground({ (count, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            if count == 0 {
                header.button.setTitle("关 注", for: .normal)
                header.button.backgroundColor = UIColor.lightGray
            } else {
                header.button.setTitle("✅ 已关注", for: .normal)
                header.button.backgroundColor = UIColor.green
            }
        })
        
        header.button.isUserInteractionEnabled = false
        
        
        let postsQuery = AVQuery.init(className: "Posts")
        postsQuery.whereKey("username", equalTo: guestArray.last?.username)
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
        
        
        
        
        let followersQuery = AVUser.followerQuery((guestArray.last?.objectId)!)
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
        
        
        
        
        
        let followeesQuery = AVUser.followeeQuery((guestArray.last?.objectId)!)
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
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.height {
            self.loadMore()
        }
    }
    
    
    func loadMore() {
        if page <= picArray.count {
            page = page + 12
            
            let query = AVQuery.init(className: "Posts")
            query.whereKey("username", equalTo: guestArray.last?.username)
            query.limit = page
            query.findObjectsInBackground { (objects, error) in
                if error == nil{
                    self.puuidArray.removeAll(keepingCapacity: false)
                    self.picArray.removeAll(keepingCapacity: false)
                    
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
    }
    
    func loadPosts() {
        let query = AVQuery.init(className: "Posts")
        query.whereKey("username", equalTo: guestArray.last?.username)
        query.limit = page
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.puuidArray.removeAll()
                self.picArray.removeAll()
            
            
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
    
    @objc func refresh() {
        self.collectionView.reloadData()
        self.refresher.endRefreshing()
    }
    
    
    @objc func back(_: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        if !guestArray.isEmpty {
            guestArray.removeLast()
        }
    }
    @objc func postsTap(_ recognizer:UITapGestureRecognizer) {
        if !picArray.isEmpty {
            let index = IndexPath.init(item: 0, section: 0)
            self.collectionView.scrollToItem(at: index, at: UICollectionView.ScrollPosition.top, animated: true)
        }
        
    }
    
    @objc func FollowersTap(_ recognizer:UITapGestureRecognizer) {
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
        followers.user = (guestArray.last)!
        followers.show = "关 注 者"
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    
    
    @objc func FolloweeTap(_ recognizer:UITapGestureRecognizer) {
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
        followings.user = (guestArray.last)!
        followings.show = "关 注"
        self.navigationController?.pushViewController(followings, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PictureCell
        picArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.picImg.image = UIImage.init(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postuid.append(puuidArray[indexPath.row])
        print(postuid)
        let postViewController = self.storyboard?.instantiateViewController(withIdentifier: "PostVC") as! PostViewController
        self.navigationController?.pushViewController(postViewController, animated: true)
    }
    
    
    
    
    
}
