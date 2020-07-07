//
//  ReportPickerViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/07/08.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ReportPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    
    var password = ""
    var reportKind = ""
    var reportContent = ""
    var alertController: UIAlertController!
    let postRefMessage = Firestore.firestore().collection("Rooms")
    let postRefReport = Firestore.firestore().collection("Reports")
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return reportContents.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reportKind = reportContents[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return reportContents[row]
    }

    
 
    @IBOutlet weak var contentPicker: UIPickerView!
    @IBOutlet weak var reportcontentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    let reportContents = ["スパム/宣伝目的","性的嫌がらせ","迷惑行為","暴力または危険な行為","その他"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentPicker.delegate = self
        contentPicker.dataSource = self
        reportcontentTextView.delegate = self
        reportcontentTextView.layer.cornerRadius = 5
        reportcontentTextView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        reportcontentTextView.layer.shadowColor = UIColor.black.cgColor
        reportcontentTextView.layer.shadowOpacity = 0.6
        reportcontentTextView.layer.shadowRadius = 4
        
        submitButton.layer.cornerRadius = 5
        submitButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        submitButton.layer.shadowColor = UIColor.black.cgColor
        submitButton.layer.shadowOpacity = 0.6
        submitButton.layer.shadowRadius = 4
        submitButton.isEnabled = false
        submitButton.setTitleColor(UIColor.gray, for: .normal)

        // Do any additional setup after loading the view.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print("a")
        var textViewCount = reportcontentTextView.text.count
        if textViewCount >= 1 {
            submitButton.isEnabled = true
            submitButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            submitButton.isEnabled = false
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.reportcontentTextView.isFirstResponder) {
            self.reportcontentTextView.resignFirstResponder()
        }
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.reportcontentTextView.resignFirstResponder()
        return true
    }
    
    private func inputReport(kind: String, content: String) {
        
        let docData = [
            "kind": kind,
            "content": content,
            "sender": UIDevice.current.identifierForVendor!.uuidString,
            "time": Timestamp()
            
            ] as [String : Any]
        postRefMessage.document(password).collection("reports").document().setData(docData) {(err) in
        if let err = err {
            print("メッセージ情報の保存に失敗しました。\(err)")
            return
        }
            
        }
        postRefReport.document(password).collection("reports").document().setData(docData) {(err) in
        if let err = err {
            print("メッセージ情報の保存に失敗しました。\(err)")
            return
        }
            
        }
        
    }
    @IBAction func submitButton(_ sender: Any) {
        reportContent = reportcontentTextView.text
        reportcontentTextView.text = ""
        inputReport(kind: reportKind, content: reportContent)
        messageAlert(title: "通報しました", message: "")
        
    }
    func messageAlert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler:{
                                        (action: UIAlertAction!) -> Void in
                                        print("OK")
                                        self.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true)
    }

}
