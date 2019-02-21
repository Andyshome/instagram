//
//  PostViewControllerCell.swift
//  instagram
//
//  Created by 邱子昂 on 2019-01-09.
//  Copyright © 2019 邱子昂. All rights reserved.
//

import UIKit




class PostViewControllerCell: UITableViewCell {
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var picImg: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var puuidLabel: UILabel!
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        let width = UIScreen.main.bounds.width
        
        avaImg.translatesAutoresizingMaskIntoConstraints = false
        usernameButton.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        picImg.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        puuidLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let picWidth = width - 20
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[ava(30)]-10-[pic(\(picWidth))]-5-[like(30)]", options: [], metrics: nil, views: ["ava": avaImg, "pic": picImg, "like": likeButton]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-10-[username]", options: [], metrics: nil, views: ["username": usernameButton]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[comment(30)]", options: [], metrics: nil, views: ["pic": picImg, "comment": commentButton]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-15-[date]", options: [], metrics: nil, views: ["date": dateLabel]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[like]-5-[title]-5-|", options: [], metrics: nil, views: ["like": likeButton, "title": bioLabel]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-5-[more(30)]", options: [], metrics: nil, views: ["pic": picImg, "more": moreButton]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[pic]-10-[likes]", options: [], metrics: nil, views: ["pic": picImg, "likes": likeLabel]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-10-[ava(30)]-10-[username]", options: [], metrics: nil, views: ["ava": avaImg, "username": usernameButton]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[pic]-0-|", options: [], metrics: nil, views: ["pic": picImg]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[like(30)]-10-[likes]-20-[comment(30)]", options: [], metrics: nil, views: ["like": likeButton, "likes": likeLabel, "comment": commentButton]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[more(30)]-15-|", options: [], metrics: nil, views: ["more": moreButton]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[title]-15-|", options: [], metrics: nil, views: ["title": bioLabel]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[date]-10-|", options: [], metrics: nil, views: ["date": dateLabel]))
        
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.layer.borderWidth = 1
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.masksToBounds = false
        avaImg.clipsToBounds = true

        likeButton.setTitleColor(.clear, for: .normal)
        setUpTap()
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func LikeClick(_ sender: UIButton) {
        let title = sender.title(for: .normal)
        if title == "unlike" {
            let object = AVObject.init(className: "Likes")
            object["by"] = AVUser.current()?.username
            object["to"] = puuidLabel.text
            object.saveInBackground { (success, error) in
                if success {
                    self.like()
                }
            }
        } else {
            let query = AVQuery.init(className: "Likes")
            query.whereKey("by", equalTo: AVUser.current()?.username)
            query.whereKey("to", equalTo: puuidLabel.text)
            query.deleteAllInBackground({ (result, error) in
                if result == true {
                    self.unlike()
                }
            })
                
            
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpTap() {
        let likeTap = UITapGestureRecognizer.init(target: self, action: #selector(likeTapped))
        likeTap.numberOfTapsRequired = 2
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(likeTap)
    }
    @objc func likeTapped() {
        let likePic = UIImageView.init(image: UIImage.init(named: "unlike.png"))
        likePic.frame.size.width = picImg.frame.width / 2
        likePic.frame.size.height = picImg.frame.height / 2
        likePic.center = picImg.center
        likePic.alpha = 0.7
        self.addSubview(likePic)
        UIView.animate(withDuration: 0.4) {
            likePic.alpha = 0
            likePic.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        let title = likeButton.title(for: .normal)
        
        if title == "unlike" {
            let object = AVObject.init(className: "Likes")
            object["by"] = AVUser.current()?.username
            object["to"] = puuidLabel.text
            object.saveInBackground { (success, error) in
                if success {
                    self.like()
                }
            }
        }
        
    }
    
    
    
    func unlike() {
        likeButton.setTitle("unlike", for: .normal)
        likeButton.setBackgroundImage(UIImage.init(named: "unlike.png"), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name.init("liked"), object: nil)
    }
    
    func like() {
        likeButton.setTitle("like", for: .normal)
        likeButton.setBackgroundImage(UIImage.init(named: "like.png"), for: .normal)
        NotificationCenter.default.post(name: NSNotification.Name.init("liked"), object: nil)
    }
}
