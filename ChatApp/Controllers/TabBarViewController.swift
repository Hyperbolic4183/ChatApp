//
//  TabBarViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/26.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
UITabBar.appearance().barTintColor = UIColor(red: 174/255, green: 238/255, blue: 226/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
    }
}
