//
//  ResetPasswordVC.swift
//  instagram
//
//  Created by 邱子昂 on 2018/9/9.
//  Copyright © 2018年 邱子昂. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        emailTxt.frame = CGRect(x: 10, y: 130 , width: self.view.frame.width - 20, height: 30)
        resetBtn.frame = CGRect(x: 20, y: emailTxt.frame.origin.y + 60, width: self.view.frame.width / 4, height: 30)
        cancelBtn.frame = CGRect(x: self.view.frame.width - 20 - self.view.frame.width/4, y: resetBtn.frame.origin.y, width: self.view.frame.width/4, height: 30)
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        // Do any additional setup after loading the view.
    }
    @IBAction func resetBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        if emailTxt.text!.isEmpty {
            let alert = UIAlertController(title: "请注意", message: "电子邮件不能为空", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert,animated: true,completion: nil)
        }
        AVUser.requestPasswordResetForEmail(inBackground: emailTxt.text!) { (success:Bool,error:Error?) in
            if success {
                let alert = UIAlertController(title: "请注意", message: "重制密码链接已经发送到您的电子邮件", preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert,animated: true,completion: nil)
            } else {
                print(error!.localizedDescription)
            }
            
        }
    }
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    @IBAction func cancelBtnClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
