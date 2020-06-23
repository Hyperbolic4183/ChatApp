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
class RoomMakeViewController: UIViewController, UITextFieldDelegate {

    var postDic = [
    "password": String()
    
    ] as [String : Any]
    
    
    
    var databaseRef: DatabaseReference!
    var ref = Database.database().reference()
    let postRef = Firestore.firestore().collection("Rooms")
    
    var password: String = ""
    var renketsuPassword = ""
    @IBOutlet weak var makeRoomButton: UIButton!
    @IBOutlet weak var searchRoomButton: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomPasswordTextField: UITextField!
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomNameTextField.delegate = self
        roomPasswordTextField.delegate = self
        makeRoomButton.isEnabled = false
        searchRoomButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.password = roomNameTextField.text!+roomPasswordTextField.text!
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = (textField.text! as NSString).replacingCharacters(in: range, with: string).count
        
        switch textField.tag {
        
        case 1:
            if (textLength >= 6 && textLength <= 15) {
                makeRoomButton.isEnabled = true
                searchRoomButton.isEnabled = true
            } else {
                makeRoomButton.isEnabled = false
                searchRoomButton.isEnabled = false
            }
        default:
            break
        }



        return true
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
        
        password = "\(roomNameTextField.text!)\(roomPasswordTextField.text!)"
        SVProgressHUD.show()
        postRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("パスワードが存在しない")
                return
            }
            for document in querySnapshot!.documents {
                    
                    if self.password == document.documentID {
                        print("ルームを発見")
                        
                        SVProgressHUD.dismiss()
                        //メッセージの数を取得し値を渡す
                        //一度退出し、退出後にメッセージが追加され、その後入室するとクラッシュする。　端末に状態を保存するか、入手時にドキュメントを取得する
                        self.postRef.document(self.password).collection("Messages")
                        
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
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? ChatViewController
        nextVC?.roomPassword = self.password
        nextVC?.roomName = roomNameTextField.text!

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
    
}

extension RoomMakeViewController: UIApplicationDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
}
