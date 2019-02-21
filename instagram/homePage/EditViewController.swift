//
//  EditViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2019-01-04.
//  Copyright © 2019 邱子昂. All rights reserved.
//

import UIKit

class EditViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextView!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var telTxt: UITextField!
    @IBOutlet weak var genderTxt: UITextField!
    @IBOutlet weak var TitleLabel: UILabel!
    var genderPicker : UIPickerView!
    let gender = ["男","女"]
    // 根据需要，设置滚动视图的高度
    var scrollViewHeight:CGFloat = 0
    // 获取虚拟键盘的大小
    var keyboard:CGRect = CGRect()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        aligment()
        genderSetUp()
        addNotification()
        setUpTextFieldDelegate()
        information()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = self.view.frame.height
        // Do any additional setup after loading the view.
    }
    
    func setUpTextFieldDelegate() {
        fullnameTxt.delegate = self
        usernameTxt.delegate = self
        webTxt.delegate = self
        emailTxt.delegate = self
        telTxt.delegate = self
    }
    
    func genderSetUp() {
        genderPicker = UIPickerView()
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderPicker.backgroundColor = UIColor.groupTableViewBackground
        genderPicker.showsSelectionIndicator = true
        genderTxt.inputView = genderPicker
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
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap(recognizer:)))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImg(recognizer:)))
        imgTap.numberOfTapsRequired = 1
        avaImg.isUserInteractionEnabled = true
        avaImg.addGestureRecognizer(imgTap)
    }
    
    
    
    @objc func showKeyboard(notificaton:Notification)  {
        var userInfo = notificaton.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    @objc func hideKeyboard(notification:Notification) {
        // 当虚拟键盘消失后，将滚动视图的实际高度改变为屏幕的高度值。
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    // 隐藏视图中的虚拟键盘
    @objc func hideKeyboardTap(recognizer:UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
    }
    
    
    
    
    @IBAction func saveClicked(_ sender: Any) {
        guard usernameTxt.text != "" && emailTxt.text != "" else {
            alert(message: "请完成所有关键信息")
            return
        }
        if !validateEmail(email: emailTxt.text!) {
            alert(message: "非法邮件格式，请检查")
        }
        let user = AVUser.current()
        user?.username = usernameTxt.text?.lowercased()
        user?.email = emailTxt.text?.lowercased()
        user?["fullname"] = fullnameTxt.text?.lowercased()
        user?["web"] = webTxt.text?.lowercased()
        user?["bio"] = bioTxt.text
        if telTxt.text!.isEmpty {
            user?.mobilePhoneNumber = ""
        } else {
            user?.mobilePhoneNumber = telTxt.text
        }
        if genderTxt.text!.isEmpty {
            user?["gender"] = ""
        } else {
            user?["gender"] = genderTxt.text
        }
       
        let avaData = avaImg.image?.jpegData(compressionQuality: 0.5)
        let avaFile = AVFile(name: "ava.jpg", data: avaData!)
        user?["ava"] = avaFile
        
        
        user?.saveInBackground({ (result, error) in
            if result {
                self.view.endEditing(true)
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name.init("reload"), object: nil)
            } else {
                print(error?.localizedDescription)
            }
            
        })
        
        
    }
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func information() {
        let ava = AVUser.current()?.object(forKey: "ava") as! AVFile
        ava.getDataInBackground { (data, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.avaImg.image = UIImage.init(data: data!)
            self.usernameTxt.text = AVUser.current()?.username
            self.fullnameTxt.text = AVUser.current()?.object(forKey: "fullname") as? String
            self.bioTxt.text = AVUser.current()?.object(forKey: "bio") as? String
            self.webTxt.text = AVUser.current()?.object(forKey: "web") as? String
            self.emailTxt.text = AVUser.current()?.email
            self.telTxt.text = AVUser.current()?.mobilePhoneNumber
            self.genderTxt.text = AVUser.current()?.object(forKey: "gender") as? String
        }
    }
    
    func aligment() {
        let width = self.view.frame.width
        let height = self.view.frame.height
        usernameTxt.isUserInteractionEnabled = false
        scrollView.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        avaImg.frame = CGRect.init(x: width - 68 - 10, y: 15, width: 68, height: 68)
        
        fullnameTxt.frame = CGRect.init(x: 10, y: avaImg.frame.origin.y, width: width - avaImg.frame.width - 30, height: 30)
        usernameTxt.frame = CGRect.init(x: 10, y: fullnameTxt.frame.origin.y + 40, width: width - avaImg.frame.width - 30, height: 30)
        webTxt.frame = CGRect.init(x: 10, y: usernameTxt.frame.origin.y + 40, width: width - 20, height: 30)
        bioTxt.frame = CGRect.init(x: 10, y: webTxt.frame.origin.y + 40, width: width - 20, height: 60)
        //给biotxt添加圆角
        bioTxt.layer.borderWidth = 1
        bioTxt.layer.borderColor = UIColor.blue.cgColor
        bioTxt.layer.cornerRadius = bioTxt.frame.width / 50
        bioTxt.clipsToBounds = true
        
        
        TitleLabel.frame = CGRect.init(x: 10, y: bioTxt.frame.origin.y + 100, width: width - 20, height: 30)
        emailTxt.frame = CGRect.init(x: 10, y: TitleLabel.frame.origin.y + 40, width: width - 20, height: 30)
        telTxt.frame = CGRect.init(x: 10, y: emailTxt.frame.origin.y + 40, width: width - 20, height: 30)
        genderTxt.frame = CGRect.init(x: 10, y: telTxt.frame.origin.y + 40, width: width - 20, height: 30)
        
        avaImg.layer.borderWidth = 1
        avaImg.layer.masksToBounds = false
        avaImg.layer.borderColor = UIColor.white.cgColor
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        
        
    }
    
    // Set up picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gender.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gender[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTxt.text = gender[row]
        self.view.endEditing(true)
    }
    
    
    func validateEmail(email:String) -> Bool {
        let regex = "\\w[-\\w.+]*@([A-Za-z0-9][-A-Za-z0-9]+\\.)+[A-Za-z]{2,14}"
        let range = email.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    
    
    
    func validateWeb(web:String) -> Bool {
        let regex = "www\\.[A-Za-z0-9._%+-]+\\.[A-Za-z]{2,14}"
        let range = web.range(of: regex, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    
    func alert(message:String) {
        let alert = UIAlertController(title: "请注意", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("select picture error!")
            return
        }
        let width = self.view.frame.width
        let height = self.view.frame.height
        avaImg.image = selectedImage
        avaImg.frame = CGRect.init(x: width - 78, y: 15, width: 68, height: 68)
        avaImg.layer.cornerRadius = avaImg.frame.width / 2
        avaImg.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    @objc func loadImg(recognizer:UITapGestureRecognizer) -> Void {
        let picker = UIImagePickerController()
        print("presenting")
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
