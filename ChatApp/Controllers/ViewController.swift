//
//  ViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/30.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    let firstLunchKey = "firstLunchKey"
    private let checkedImage = UIImage(named: "check_on")
    private let uncheckedImage = UIImage(named: "check_off")
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var over18Button: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        agreeButton.setImage(uncheckedImage, for: .normal)
        agreeButton.setImage(checkedImage, for: .selected)
        over18Button.setImage(uncheckedImage, for: .normal)
        over18Button.setImage(checkedImage, for: .selected)
        check()

        // Do any additional setup after loading the view.
    }
    @IBAction func agreeButton(_ sender: Any) {
        agreeButton.isSelected = !agreeButton.isSelected
        check()
    }
    @IBAction func over18Button(_ sender: Any) {
        over18Button.isSelected = !over18Button.isSelected
        check()
    }
    
    @IBAction func startButton(_ sender: Any) {
        userDefaults.set(false, forKey: firstLunchKey)
        dismiss(animated: true, completion: nil)
    }
    
    func check() {
        if (agreeButton.isSelected && over18Button.isSelected) {
            print("OK")
            startButton.isEnabled = true
            startButton.setTitleColor(UIColor.black, for: .normal)
            
        } else {
            print("NG")
            startButton.isEnabled = false
            startButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
}
