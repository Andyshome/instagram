//
//  navigationViewController.swift
//  instagram
//
//  Created by 邱子昂 on 2019-01-16.
//  Copyright © 2019 邱子昂. All rights reserved.
//

import UIKit

class navigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes = [.foregroundColor:UIColor.white]
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.barTintColor = UIColor.init(red: 60.0/255.0, green: 120.0/255.0, blue: 200.0/255.0, alpha: 1)
        self.navigationBar.isTranslucent = false
        // Do any additional setup after loading the view.
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
