//
//  forbidenViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/07/01.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class forbidenViewController: UIViewController {

    @IBOutlet weak var forbiddenLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        forbiddenLabel.layer.cornerRadius = 5
        forbiddenLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        forbiddenLabel.layer.shadowColor = UIColor.black.cgColor
        forbiddenLabel.layer.shadowOpacity = 0.6
        forbiddenLabel.layer.shadowRadius = 4

        // Do any additional setup after loading the view.
    }
    

}
