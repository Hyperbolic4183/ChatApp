//
//  testViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/22.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import SwiftUI
class testViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let testSwiftUI = UIHostingController(rootView:
            ChatRoomBar()
        )
        self.addChild(testSwiftUI)
        self.view.addSubview(testSwiftUI.view)
        testSwiftUI.didMove(toParent: self)
        
        testSwiftUI.view.translatesAutoresizingMaskIntoConstraints = false
        
        testSwiftUI.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //frameの底からのY座標
        testSwiftUI.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        //右からのpaddingをどれだけ取るか
        testSwiftUI.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        //左からのpaddingをどれだけ取るか
        //testSwiftUI.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        //画面したからframeのY座標
        testSwiftUI.view.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    

}
