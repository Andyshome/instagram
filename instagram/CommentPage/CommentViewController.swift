//
//  CommentViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2019-01-20.
//  Copyright © 2019 邱子昂. All rights reserved.
//

import UIKit

struct comment {
    var commentuid : String = ""
    var commentowner : String = "" 
}

var commentArray : [comment] = []
class CommentViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    var refresher = UIRefreshControl.init()
    var tableViewHeight : CGFloat = 0
    var commentY : CGFloat = 0
    var commentHeight : CGFloat = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.navigationItem.title = "评论"
        self.navigationItem.hidesBackButton = true
        let backBtn = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = backBtn
        self.sendButton.isEnabled = false
        addNotification()
        let backSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(back(_:)))
        backSwipe.direction = .right
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(backSwipe)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKeyboard),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    @objc func showKeyboard(notificaton:Notification)  {
        var userInfo = notificaton.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        UIView.animate(withDuration: 0.4) {
            self.tableView.frame.size.height = self.tableViewHeight - keyboardFrame.height
            self.commentText.frame.origin.y = self.commentY - keyboardFrame.height
            self.sendButton.frame.origin.y = self.commentY - keyboardFrame.height
        }
        
    }
    
    
    @objc func hideKeyboard(notification:Notification) {
        // 当虚拟键盘消失后，将滚动视图的实际高度改变为屏幕的高度值。
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        UIView.animate(withDuration: 0.4) {
            self.tableView.frame.size.height = self.tableViewHeight
            self.commentText.frame.origin.y = self.commentY
            self.sendButton.frame.origin.y = self.commentY
        }
        
    }
    
    
    @objc func back(_ sender:UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        if !commentArray.isEmpty {
            commentArray.removeLast()
        }
        
    }
    
    func setUp() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        tableView.frame = CGRect(x: 0, y: 0, width: width, height: height / 1.096 - self.navigationController!.navigationBar.frame.height - 20)
        
        tableView.estimatedRowHeight = width / 5.33
        tableView.rowHeight = UITableView.automaticDimension
        
        commentText.frame = CGRect(x: 10, y: tableView.frame.height + height / 56.8, width: width / 1.306, height: 33)
        
        commentText.layer.cornerRadius = commentText.frame.width / 50
        
        commentText.delegate = self
        commentText.isUserInteractionEnabled = true
        sendButton.frame = CGRect(x: commentText.frame.origin.x + commentText.frame.width + width / 32, y: commentText.frame.origin.y, width: width - (commentText.frame.origin.x + commentText.frame.width) - width / 32 * 2, height: commentText.frame.height)
        
        tableViewHeight = tableView.frame.height
        commentY = commentText.frame.origin.y
        commentHeight = commentText.frame.height
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
