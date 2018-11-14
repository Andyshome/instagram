//
//  FollowersCell.swift
//  instagram
//
//  Created by 邱子昂 on 2018/11/13.
//  Copyright © 2018 邱子昂. All rights reserved.
//

import UIKit

class FollowersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLable: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    var user : AVUser!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
    }
    

    @IBAction func followBtnClicked(_ sender: UIButton) {
        let title = followBtn.titleLabel?.text
        
        if title == "关 注" {
            guard user != nil else {
                return
            }
            
            AVUser.current()?.follow(user.objectId!, andCallback: { (success, error) in
                if success {
                    self.followBtn.setTitle("✅ 已关注", for: .normal)
                    self.followBtn.backgroundColor = UIColor.green
                } else {
                    print(error?.localizedDescription)
                }
            })
        } else {
            guard user != nil else {
                return
            }
            AVUser.current()?.unfollow(user.objectId!, andCallback: { (success, error) in
                if success {
                    self.followBtn.setTitle("关 注", for: .normal)
                    self.followBtn.backgroundColor = UIColor.lightGray
                }
            })
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
