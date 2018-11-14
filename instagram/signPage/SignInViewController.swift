//
//  SignInVC.swift
//  instagram
//
//  Created by 邱子昂 on 2018/9/7.
//  Copyright © 2018年 邱子昂. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var forgotBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        bg.image = UIImage(named: "bg.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
        label.font = UIFont(name: "Pacifico", size: 25   )
        label.frame = CGRect(x: 10, y: 130, width: self.view.frame.width - 20, height: 50)
        usernameTxt.frame = CGRect(x: 10, y: label.frame.origin.y + 140, width: self.view.frame.width - 20, height: 30)
        passwordTxt.frame = CGRect(x: 10, y: usernameTxt.frame.origin.y + 80, width: self.view.frame.width - 20, height: 30)
        forgotBtn.frame = CGRect(x: 10, y: passwordTxt.frame.origin.y + 60, width: self.view.frame.width - 20, height: 30)
        signInBtn.frame = CGRect(x: 20, y: forgotBtn.frame.origin.y + 80, width: self.view.frame.width / 4, height: 30)
        signUpBtn.frame = CGRect(x: self.view.frame.width - self.view.frame.width/4 - 20, y: forgotBtn.frame.origin.y + 80, width: self.view.frame.width/4, height: 30)
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    
    
    @IBAction func signinBtn_clicked(_ sender: UIButton) {
        print("hello,world")
        
        self.view.endEditing(true)
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            let alert = UIAlertController(title: "请注意", message: "请填写所有信息！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        AVUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:AVUser?,error:Error?) in
            if  error == nil {
                UserDefaults.standard.set(user!.username, forKey: "username")
                UserDefaults.standard.synchronize()
                
                
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }
            
        }
        
        
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
