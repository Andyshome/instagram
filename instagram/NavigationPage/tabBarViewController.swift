//
//  tabBarViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2019-01-16.
//  Copyright © 2019 邱子昂. All rights reserved.
//

import UIKit

class tabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.init(red: 37.0/255.0, green: 39.0/255.0, blue: 42.0/255.0, alpha: 1)
        self.tabBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
