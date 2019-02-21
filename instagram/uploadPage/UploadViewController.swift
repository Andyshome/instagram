//
//  UploadViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2019-01-07.
//  Copyright © 2019 邱子昂. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate{

    @IBOutlet weak var picImg: UIImageView!
    
    @IBOutlet weak var bioTextField: UITextView!
  
    @IBOutlet weak var publishButton: UIButton!
    
    @IBOutlet weak var removeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alignment()
        publishButton.isEnabled = false
        publishButton.backgroundColor = UIColor.lightGray
        let picTap = UITapGestureRecognizer.init(target: self, action: #selector(loadImg(recognizer:)))
        picTap.numberOfTapsRequired = 1
        self.picImg.isUserInteractionEnabled = true
        self.picImg.addGestureRecognizer(picTap)
        bioTextField.delegate = self
        removeButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func removeImage(_ sender: Any) {
        picImg.image = UIImage.init(named: "pbg.jpg")
        publishButton.backgroundColor = UIColor.lightGray
        publishButton.isEnabled = false
        removeButton.isHidden = true
        let picTap = UITapGestureRecognizer.init(target: self, action: #selector(loadImg(recognizer:)))
        picTap.numberOfTapsRequired = 1
        self.picImg.isUserInteractionEnabled = true
        self.picImg.addGestureRecognizer(picTap)
    }
    
    
    
    func alignment() {
        let width = self.view.frame.width
        
        picImg.frame = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        
        bioTextField.frame = CGRect(x: picImg.frame.width + 25, y: picImg.frame.origin.y, width: width - bioTextField.frame.origin.x - 10, height: picImg.frame.height)
        
        publishButton.frame = CGRect(x: 0, y: self.tabBarController!.tabBar.frame.origin.y - width / 3, width: width, height: width / 8)
        
        removeButton.frame = CGRect.init(x: picImg.frame.origin.x, y: picImg.frame.origin.y + picImg.frame.height, width: picImg.frame.width, height: 30)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
    }

    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            print("select picture error!")
            return
        }
        publishButton.isEnabled = true
        publishButton.backgroundColor = UIColor.orange
        picImg.image = selectedImage
        let zoomTap = UITapGestureRecognizer.init(target: self, action: #selector(zoomImg))
        zoomTap.numberOfTapsRequired = 1
        picImg.isUserInteractionEnabled = true
        picImg.addGestureRecognizer(zoomTap)
        removeButton.isHidden = false
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
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func publishClicked(_ sender: Any) {
        self.view.endEditing(true)
        let object = AVObject.init(className: "Posts")
        object["username"] = AVUser.current()?.username
        object["ava"] = AVUser.current()?.value(forKey: "ava") as! AVFile
        object["puuid"] = "\(AVUser.current()!.username!) \(NSUUID().uuidString)"
        
        if bioTextField.text.isEmpty  {
            object["title"] = ""
        } else {
            object["title"] = bioTextField.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        
        let imageData = picImg.image?.jpegData(compressionQuality: 0.5)
        let imageFile = AVFile(name: "post.jpg", data: imageData!)
        object["pic"] = imageFile
        let loadAnimation = UIViewController.displaySpinner(onView: self.view)
        object.saveInBackground { (success, error) in
            if error == nil {
                self.picImg.image = UIImage.init(named: "pbg.jpg")
                self.bioTextField.text = ""
                self.removeButton.isHidden = true
                self.publishButton.isEnabled = false
                self.publishButton.backgroundColor = UIColor.lightGray
                UIViewController.removeSpinner(spinner: loadAnimation)
                NotificationCenter.default.post(name: NSNotification.Name.init("uploaded"), object: nil)
                let picTap = UITapGestureRecognizer.init(target: self, action: #selector(self.loadImg(recognizer:)))
                picTap.numberOfTapsRequired = 1
                self.picImg.isUserInteractionEnabled = true
                self.picImg.addGestureRecognizer(picTap)
                self.tabBarController?.selectedIndex = 0
            } else {
                print(error?.localizedDescription)
                self.alert(message: "网络错误，请检查网络连接！")
            }
        }
    }
    
    @objc func zoomImg() {
        self.view.endEditing(true)
        let width = self.view.frame.width
        let zoomed = CGRect.init(x: 0, y: self.view.center.y - self.view.center.x - (self.navigationController?.navigationBar.frame.height)! * 1.5, width: width, height: width)
        let unzoomed = CGRect(x: 15, y: 15, width: width / 4.5, height: width / 4.5)
        
        
        if picImg.frame == unzoomed {
            UIView.animate(withDuration: 0.3) {
                
                self.picImg.frame = zoomed
                self.view.backgroundColor = UIColor.black
                self.bioTextField.isHidden = true
                self.publishButton.isHidden = true
                self.removeButton.isHidden = true
                
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                
                self.picImg.frame = unzoomed
                self.view.backgroundColor = UIColor.white
                self.bioTextField.isHidden = false
                self.publishButton.isHidden = false
                self.removeButton.isHidden = false
                
            }
        }
    }
    
    func alert(message:String) {
        let alert = UIAlertController(title: "请注意", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
