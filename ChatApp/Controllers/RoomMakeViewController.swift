//
//  RoomMakeViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/18.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import SwiftUI
import MessageKit
import InputBarAccessoryView


class RoomMakeViewController: UIViewController, UITextFieldDelegate {

    var postDic = [
    "password": String()
    
    ] as [String : Any]

    
    var databaseRef: DatabaseReference!
    var ref = Database.database().reference()
    let postRef = Firestore.firestore().collection("Rooms")
    var userDefaults = UserDefaults.standard

    
    var password: String = ""
    var roomNameTextFieldBool = Bool()
    var roompasswordTextFieldBool = Bool()
    
    @IBOutlet weak var makeRoomButton: UIButton!
    @IBOutlet weak var searchRoomButton: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomPasswordTextField: UITextField!
    @IBOutlet weak var roomNameAutoButton: UIButton!
    @IBOutlet weak var roomPasswordAutoButton: UIButton!
    
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        checkButton()

        
    }
    
    func setupViews() {
        roomNameTextFieldBool = false
        roompasswordTextFieldBool = false
        roomNameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomNameTextField.layer.shadowColor = UIColor.black.cgColor
        roomNameTextField.layer.shadowOpacity = 0.6
        roomNameTextField.layer.shadowRadius = 4
        roomNameTextField.delegate = self
        
        roomPasswordTextField.delegate = self
        roomPasswordTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomPasswordTextField.layer.shadowColor = UIColor.black.cgColor
        roomPasswordTextField.layer.shadowOpacity = 0.6
        roomPasswordTextField.layer.shadowRadius = 4
        
        makeRoomButton.isEnabled = false
        makeRoomButton.layer.cornerRadius = 25
        makeRoomButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        makeRoomButton.layer.shadowColor = UIColor.black.cgColor
        makeRoomButton.layer.shadowOpacity = 0.6
        makeRoomButton.layer.shadowRadius = 4
        //makeRoomButton.setTitleColor(UIColor.gray, for: .normal)
        
        searchRoomButton.isEnabled = false
        searchRoomButton.layer.cornerRadius = 25
        searchRoomButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        searchRoomButton.layer.shadowColor = UIColor.black.cgColor
        searchRoomButton.layer.shadowOpacity = 0.6
        searchRoomButton.layer.shadowRadius = 4
        //searchRoomButton.setTitleColor(UIColor.gray, for: .normal)
        
        roomNameAutoButton.layer.cornerRadius = 25
        roomNameAutoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        roomNameAutoButton.layer.shadowColor = UIColor.black.cgColor
        roomNameAutoButton.layer.shadowOpacity = 0.6
        roomNameAutoButton.layer.shadowRadius = 4
        roomNameAutoButton.setTitleColor(UIColor.white, for: .normal)
        
        roomPasswordAutoButton.layer.cornerRadius = 25
        roomPasswordAutoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomPasswordAutoButton.layer.shadowColor = UIColor.black.cgColor
        roomPasswordAutoButton.layer.shadowOpacity = 0.6
        roomPasswordAutoButton.layer.shadowRadius = 4
        roomPasswordAutoButton.setTitleColor(UIColor.white, for: .normal)
        
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func makeRoomButton(_ sender: Any) {
        
        password = roomNameTextField.text!+roomPasswordTextField.text!
        
        SVProgressHUD.show()
        
        
        
        postRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("エラーは\(err)")
                return
            }
                for document in querySnapshot!.documents {

                    if self.password == document.documentID {
                        print("同じものが見つかった")
                        SVProgressHUD.showError(withStatus: "パスワードを変更してください")
                        return
                    }
            }
            SVProgressHUD.dismiss()
            print("パスワードに被りはないです")
            self.postRef.document(self.password).setData(self.postDic)
            self.performSegue(withIdentifier: "make", sender: nil)
            return
            
        }

        roomPasswordTextField.text = ""
       
    }
    
    
    
    @IBAction func searchRoomButton(_ sender: Any) {
        
        password = roomNameTextField.text! + roomPasswordTextField.text!
        SVProgressHUD.show()
        
            
        postRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("パスワードが存在しない\(err)")
                return
            }
            for document in querySnapshot!.documents {
                    
                    if self.password == document.documentID {
                        print("ルームを発見")
                      


                        self.performSegue(withIdentifier: "make", sender: nil)

                        return
                    }
            }
            print("パスワードが存在しない")
            SVProgressHUD.showError(withStatus: "ルームが存在しません。")
            return
        }
        roomPasswordTextField.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = (textField.text! as NSString).replacingCharacters(in: range, with: string).count
        
        switch textField.tag {
        case 0:
            if textLength < 1 {
                roomNameTextFieldBool = false
            } else {
                roomNameTextFieldBool = true
            }
            checkButton()
        case 1:
            if textLength >= 10 {
                roompasswordTextFieldBool = true
            } else {
                roompasswordTextFieldBool = false
            }
            checkButton()
        default:
            break
        }

        return true
    }
    
    @IBAction func roomNameAutoButton(_ sender: Any) {
        roomNameTextField.text = randomString(length: 10)
        roomNameTextFieldBool = true
        checkButton()
    }
    
    @IBAction func roomPasswordAutoButton(_ sender: Any) {
        roomPasswordTextField.text = randomString(length: 10)
        roompasswordTextFieldBool = true
        checkButton()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? ChatViewController
        nextVC?.password = self.password
        nextVC?.roomName = roomNameTextField.text!
        nextVC?.messages = []

        switch segue.identifier {
        case "search":
            nextVC?.senderId = "other"
        case "make":
            nextVC?.senderId = "self"
        default:
            return
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        roomNameTextField.text = ""
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

extension RoomMakeViewController: UIApplicationDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
    
    private func checkButton() {
        if roomNameTextFieldBool && roompasswordTextFieldBool {
            makeRoomButton.isEnabled = true
            makeRoomButton.setTitleColor(UIColor.white, for: .normal)
            searchRoomButton.isEnabled = true
            searchRoomButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            makeRoomButton.isEnabled = false
            makeRoomButton.setTitleColor(UIColor.gray, for: .normal)
            searchRoomButton.isEnabled = false
            searchRoomButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
}
