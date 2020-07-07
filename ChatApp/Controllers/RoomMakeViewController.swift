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
import RealmSwift

class RoomMakeViewController: UIViewController, UITextFieldDelegate {

    var postDic = [
    "password": String()
    
    ] as [String : Any]

    
    var nameArr = try! Realm().objects(RoomName.self)
    var roomN: RoomName!
    
    var testarr: Results<RoomName>!
    var databaseRef: DatabaseReference!
    var ref = Database.database().reference()
    let postRef = Firestore.firestore().collection("Rooms")
    var userDefaults = UserDefaults.standard
    var joinedRoomNamePasswordArray = [String?]()

    
    var password: String = ""
    
    var roomNameTextFieldBool = Bool()
    var roompasswordTextFieldBool = Bool()
    
    @IBOutlet weak var makeRoomButton: UIButton!
    @IBOutlet weak var roomNameTextField: UITextField!
    @IBOutlet weak var roomPasswordTextField: UITextField!
    @IBOutlet weak var roomNameAutoButton: UIButton!
    @IBOutlet weak var roomPasswordAutoButton: UIButton!
    
    
    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(red: 24/255, green: 149/255, blue: 124/255, alpha: 1)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 129/255, blue: 124/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        setupViews()
        checkButton()
        roomPasswordTextField.delegate = self
        roomNameTextField.delegate = self
        overrideUserInterfaceStyle = .light
        //Realmの設定
        let realm = try! Realm()
        self.testarr = realm.objects(RoomName.self)
        
    }
    func setupViews() {
        
        roomNameTextFieldBool = false
        roompasswordTextFieldBool = false
        roomNameTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomNameTextField.layer.shadowColor = UIColor.black.cgColor
        roomNameTextField.layer.shadowOpacity = 0.6
        roomNameTextField.layer.shadowRadius = 4
        
        roomPasswordTextField.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomPasswordTextField.layer.shadowColor = UIColor.black.cgColor
        roomPasswordTextField.layer.shadowOpacity = 0.6
        roomPasswordTextField.layer.shadowRadius = 4
        
        makeRoomButton.isEnabled = false
        makeRoomButton.layer.cornerRadius = 5
        makeRoomButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        makeRoomButton.layer.shadowColor = UIColor.black.cgColor
        makeRoomButton.layer.shadowOpacity = 0.6
        makeRoomButton.layer.shadowRadius = 4
        
        
       
        
        roomNameAutoButton.layer.cornerRadius = 5
        roomNameAutoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        roomNameAutoButton.layer.shadowColor = UIColor.black.cgColor
        roomNameAutoButton.layer.shadowOpacity = 0.6
        roomNameAutoButton.layer.shadowRadius = 4
        roomNameAutoButton.setTitleColor(UIColor.black, for: .normal)
        
        roomPasswordAutoButton.layer.cornerRadius = 5
        roomPasswordAutoButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomPasswordAutoButton.layer.shadowColor = UIColor.black.cgColor
        roomPasswordAutoButton.layer.shadowOpacity = 0.6
        roomPasswordAutoButton.layer.shadowRadius = 4
        roomPasswordAutoButton.setTitleColor(UIColor.black, for: .normal)
        
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func makeRoomButton(_ sender: Any) {
        password = roomNameTextField.text!+roomPasswordTextField.text!
        var joinedRoomNameArray = self.userDefaults.array(forKey: "name") as? [String] ?? []
        var joinedRoomPasswordArray = self.userDefaults.array(forKey: "password") as? [String] ?? []
        
        for i in 0 ..< joinedRoomNameArray.count {
            joinedRoomNamePasswordArray.append(joinedRoomNameArray[i] + joinedRoomPasswordArray[i])
        }

        makeRoomButton.isEnabled = false
        makeRoomButton.setTitleColor(UIColor.gray, for: .normal)
       
        

        SVProgressHUD.show()
        print("test")
        postRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("エラーは\(err)")
                SVProgressHUD.showError(withStatus: "ルームが見つかりませんでした。")
                return
            }
            for joinedRoom in self.joinedRoomNamePasswordArray {
                print("パスワードは\(self.password)で参加しているルームは\(joinedRoom!)")
                if self.password == joinedRoom {
                    print("同じものが見つかった")
                    SVProgressHUD.showError(withStatus: "既に参加しています。")
                    return
            }

            }
            SVProgressHUD.showSuccess(withStatus: "成功しました")
            print("パスワードに被りはないです")


            self.postRef.document(self.password).setData(self.postDic)
            //追加　ルーム名とパスワードをUserdefaultsに保存

            //UserDefaultに入ったことのある部屋の名前とパスワードを格納
            
            joinedRoomNameArray.insert(self.roomNameTextField.text!, at: 0)
            print(self.roomNameTextField.text!)
            let ins: RoomName = RoomName()
            ins.roomName = self.roomNameTextField.text ?? ""
            ins.roomPassword = self.roomPasswordTextField.text ?? ""
            let ins2 = try! Realm()
            try! ins2.write {
                ins2.add(ins)
            }
            print("Realm1は\(self.testarr.count)")
            self.userDefaults.set(joinedRoomNameArray, forKey: "name")

            //パスワードを格納
            var joinedRoomPasswordArray = self.userDefaults.array(forKey: "password") as? [String] ?? []
            joinedRoomPasswordArray.insert(self.roomPasswordTextField.text!, at: 0)
            //joinedRoomPasswordArray.append(self.roomPasswordTextField.text!)
            self.userDefaults.set(joinedRoomPasswordArray, forKey: "password")
           // self.roomNameTextField.text! = ""
            self.roomPasswordTextField.text! = ""
            self.roomNameTextFieldBool = false
            self.roompasswordTextFieldBool = false
            
            return

        }

        
       
    }
    
     
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = (textField.text! as NSString).replacingCharacters(in: range, with: string).count
        
        switch textField.tag {
        case 0:
            if textLength >= 1 {
                roomNameTextFieldBool = true
            } else {
                roomNameTextFieldBool = false
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
        nextVC?.roomPassword = roomNameTextField.text!
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
    @IBAction func protocolButton(_ sender: Any) {
        print("test")
        //performSegue(withIdentifier: "protocol", sender: self)
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
            makeRoomButton.setTitleColor(UIColor.black, for: .normal)
            
        } else {
            makeRoomButton.isEnabled = false
            makeRoomButton.setTitleColor(UIColor.gray, for: .normal)
           
        }
    }
}
