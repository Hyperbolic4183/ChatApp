//
//  ReportViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/30.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ReportViewController: UIViewController{
    
    
    var postDic = [
    "report": String()
    
    ] as [String : Any]
    var reportString = String()
    let postRefMessage = Firestore.firestore().collection("Rooms")
    let postRefReport = Firestore.firestore().collection("Reports")
    private let checkedImage = UIImage(named: "check_on")
    private let uncheckedImage = UIImage(named: "check_off")
    var password = ""
    @IBOutlet weak var radio1Button: UIButton!
    @IBOutlet weak var radio2Button: UIButton!
    @IBOutlet weak var radio3Button: UIButton!
    @IBOutlet weak var radio4Button: UIButton!
    @IBOutlet weak var radio5Button: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("パスワードは\(password)")
        
        radio1Button.layer.cornerRadius = 5
        radio1Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        radio1Button.layer.shadowColor = UIColor.black.cgColor
        radio1Button.layer.shadowOpacity = 0.6
        radio1Button.layer.shadowRadius = 4
        
        radio2Button.layer.cornerRadius = 5
        radio2Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        radio2Button.layer.shadowColor = UIColor.black.cgColor
        radio2Button.layer.shadowOpacity = 0.6
        radio2Button.layer.shadowRadius = 4
        
        radio3Button.layer.cornerRadius = 5
        radio3Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        radio3Button.layer.shadowColor = UIColor.black.cgColor
        radio3Button.layer.shadowOpacity = 0.6
        radio3Button.layer.shadowRadius = 4
        
        radio4Button.layer.cornerRadius = 5
        radio4Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        radio4Button.layer.shadowColor = UIColor.black.cgColor
        radio4Button.layer.shadowOpacity = 0.6
        radio4Button.layer.shadowRadius = 4
        
        radio5Button.layer.cornerRadius = 5
        radio5Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        radio5Button.layer.shadowColor = UIColor.black.cgColor
        radio5Button.layer.shadowOpacity = 0.6
        radio5Button.layer.shadowRadius = 4
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOpacity = 0.6
        submitButton.layer.shadowRadius = 4
        
        
        radio1Button.setImage(uncheckedImage, for: .normal)
        radio2Button.setImage(uncheckedImage, for: .normal)
        radio3Button.setImage(uncheckedImage, for: .normal)
        radio4Button.setImage(uncheckedImage, for: .normal)
        radio5Button.setImage(uncheckedImage, for: .normal)
        radio1Button.setImage(checkedImage, for: .selected)
        radio2Button.setImage(checkedImage, for: .selected)
        radio3Button.setImage(checkedImage, for: .selected)
        radio4Button.setImage(checkedImage, for: .selected)
        radio5Button.setImage(checkedImage, for: .selected)
        submitButton.isEnabled = false
        submitButton.setTitleColor(UIColor.gray, for: .normal)
    }
    @IBAction func radio1Button(_ sender: Any) {
        radio1Button.isSelected = !radio1Button.isSelected
        reportString = "スパム/宣伝目的"
        if radio2Button.isSelected {
            radio2Button.isSelected = !radio2Button.isSelected
        }
        if radio3Button.isSelected {
            radio3Button.isSelected = !radio3Button.isSelected
        }
        if radio4Button.isSelected {
            radio4Button.isSelected = !radio4Button.isSelected
        }
        if radio5Button.isSelected {
            radio5Button.isSelected = !radio5Button.isSelected
        }
        if radio1Button.isSelected || radio2Button.isSelected || radio3Button.isSelected || radio4Button.isSelected || radio5Button.isSelected {
        submitButton.isEnabled = true
            submitButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @IBAction func radio2Button(_ sender: Any) {
        radio2Button.isSelected = !radio2Button.isSelected
        reportString = "性的嫌がらせ"
        if radio1Button.isSelected {
            radio1Button.isSelected = !radio1Button.isSelected
        }
        if radio3Button.isSelected {
            radio3Button.isSelected = !radio3Button.isSelected
        }
        if radio4Button.isSelected {
            radio4Button.isSelected = !radio4Button.isSelected
        }
        if radio5Button.isSelected {
            radio5Button.isSelected = !radio5Button.isSelected
        }
        if radio1Button.isSelected || radio2Button.isSelected || radio3Button.isSelected || radio4Button.isSelected || radio5Button.isSelected {
        submitButton.isEnabled = true
            submitButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @IBAction func radio3Button(_ sender: Any) {
        radio3Button.isSelected = !radio3Button.isSelected
        reportString = "迷惑行為"
        if radio1Button.isSelected {
            radio1Button.isSelected = !radio1Button.isSelected
        }
        if radio2Button.isSelected {
            radio2Button.isSelected = !radio2Button.isSelected
        }
        if radio4Button.isSelected {
            radio4Button.isSelected = !radio4Button.isSelected
        }
        if radio5Button.isSelected {
            radio5Button.isSelected = !radio5Button.isSelected
        }
        if radio1Button.isSelected || radio2Button.isSelected || radio3Button.isSelected || radio4Button.isSelected || radio5Button.isSelected {
        submitButton.isEnabled = true
            submitButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @IBAction func radio4Button(_ sender: Any) {
        radio4Button.isSelected = !radio4Button.isSelected
        reportString = "暴力または危険な行為"
        if radio1Button.isSelected {
            radio1Button.isSelected = !radio1Button.isSelected
        }
        if radio2Button.isSelected {
            radio2Button.isSelected = !radio2Button.isSelected
        }
        if radio3Button.isSelected {
            radio3Button.isSelected = !radio3Button.isSelected
        }
        if radio5Button.isSelected {
            radio5Button.isSelected = !radio5Button.isSelected
        }
        if radio1Button.isSelected || radio2Button.isSelected || radio3Button.isSelected || radio4Button.isSelected || radio5Button.isSelected {
        submitButton.isEnabled = true
            submitButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    @IBAction func radio5Button(_ sender: Any) {
        radio5Button.isSelected = !radio5Button.isSelected
        reportString = "その他"
        if radio1Button.isSelected {
            radio1Button.isSelected = !radio1Button.isSelected
        }
        if radio2Button.isSelected {
            radio2Button.isSelected = !radio2Button.isSelected
        }
        if radio3Button.isSelected {
            radio3Button.isSelected = !radio3Button.isSelected
        }
        if radio4Button.isSelected {
            radio4Button.isSelected = !radio4Button.isSelected
        }
        if radio1Button.isSelected || radio2Button.isSelected || radio3Button.isSelected || radio4Button.isSelected || radio5Button.isSelected {
            submitButton.isEnabled = true
            submitButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        inputReport(text: reportString)
        dismiss(animated: true, completion: nil)
    }
    
    private func inputReport(text: String) {
        let messageId = randomString(length: 20)
        let docData = [
            "message": text,
            "sender": UIDevice.current.identifierForVendor!.uuidString,
            "time": Timestamp()
            ] as [String : Any]
        postRefMessage.document(password).collection("reports").document(messageId).setData(docData) {(err) in
        if let err = err {
            print("メッセージ情報の保存に失敗しました。\(err)")
            return
        }
            
        }
        postRefReport.document(password).collection("reports").document(messageId).setData(docData) {(err) in
        if let err = err {
            print("メッセージ情報の保存に失敗しました。\(err)")
            return
        }
            
        }
        
    }
    
    func randomString(length: Int) -> String {
            let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            let len = UInt32(letters.length)

            var randomString = ""
        for _ in 0 ..< length {
                let rand = arc4random_uniform(len)
                var nextChar = letters.character(at: Int(rand))
                randomString += NSString(characters: &nextChar, length: 1) as String
            }
            return randomString
    }
    

}
