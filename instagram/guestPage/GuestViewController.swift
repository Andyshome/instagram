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
    var puuidArray = [String]()
    var picArray = [AVFile]()
    var refresher : UIRefreshControl!
    var page : Int = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.alwaysBounceVertical = true
        self.navigationItem.title = guestArray.last?.username
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        let backSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(back(_:)))
        backSwipe.direction = .right
        self.view.addGestureRecognizer(backSwipe)
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.addSubview(refresher)
        loadPosts()
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

    
    
    
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PictureCell
        picArray[indexPath.row].getDataInBackground { (data, error) in
            if error == nil {
                cell.picImg.image = UIImage.init(data: data!)
            } else {
                print(error?.localizedDescription)
            }
        }
        return cell
    }
    
    
    
    
    
    
    
}
