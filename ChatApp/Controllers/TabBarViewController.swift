//
//  TabBarViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/26.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var reportBool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
UITabBar.appearance().barTintColor = UIColor(red: 174/255, green: 238/255, blue: 226/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        let firstLunchKey = "firstLunchKey"
        if userDefaults.bool(forKey: firstLunchKey) {
        performSegue(withIdentifier: "agree", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = TermsOfServiceViewController()
        nextVC.reportBool = self.reportBool
    }
}
