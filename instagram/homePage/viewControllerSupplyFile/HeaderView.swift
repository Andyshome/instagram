//
//  HeaderView.swift
//  instagram
//
//  Created by 邱子昂 on 2018/9/13.
//  Copyright © 2018年 邱子昂. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var fullNameTxt: UILabel!
    @IBOutlet weak var webTxt: UITextView!
    @IBOutlet weak var bioTxt: UILabel!
    @IBOutlet weak var posts: UILabel!
    @IBOutlet weak var followers: UILabel!
    @IBOutlet weak var followings: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var followerTitle: UILabel!
    @IBOutlet weak var followingTitle: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    
    
    override func awakeFromNib() {
        let width = UIScreen.main.bounds.width
        
        avaImg.frame = CGRect(x: width / 16, y: width / 16, width: width / 4, height: width / 4)
        
        posts.frame = CGRect(x: width / 2.5, y: avaImg.frame.origin.y, width: 50, height: 30)
        followers.frame = CGRect(x: width / 1.6, y: avaImg.frame.origin.y, width: 50, height: 30)
        followings.frame = CGRect(x: width / 1.2, y: avaImg.frame.origin.y, width: 50, height: 30)
        
        postTitle.center = CGPoint(x: posts.center.x, y: posts.center.y + 20)
        followerTitle.center = CGPoint(x: followers.center.x, y: followers.center.y + 20)
        followingTitle.center = CGPoint(x: followings.center.x, y: followings.center.y + 20)
        
        button.frame = CGRect(x: postTitle.frame.origin.x, y: postTitle.center.y + 20, width: width - postTitle.frame.origin.x - 10, height: 30)
        button.layer.cornerRadius = button.frame.width / 50
        
        fullNameTxt.frame = CGRect(x: avaImg.frame.origin.x, y: avaImg.frame.origin.y + avaImg.frame.height, width: width - 30, height: 30)
        webTxt.frame = CGRect(x: avaImg.frame.origin.x - 5, y: fullNameTxt.frame.origin.y + 15, width: width - 30, height: 30)
        bioTxt.frame = CGRect(x: avaImg.frame.origin.x, y: webTxt.frame.origin.y + 30, width: width - 30, height: 30)
        
        // 让头像呈圆形显示
        avaImg.layer.borderWidth = 1
        avaImg.layer.masksToBounds = false
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        
        
    }
    
    
    
    
    
    
    
}
