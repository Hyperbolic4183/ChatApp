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
    let postRef = Firestore.firestore().collection("Rooms")
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
        postRef.document(password).collection("reports").document(messageId).setData(docData) {(err) in
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
