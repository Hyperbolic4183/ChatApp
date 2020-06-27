//
//  PauseViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/18.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import Firebase

class PauseViewController: UIViewController {

    var roomPassword = ""
    var roomName = ""
    var password = ""
    var joinedRoomName: [String?] = []
    var joinedRoomPassword: [String?] = []
    var userDefaults = UserDefaults.standard
    var messageArrayForDelete = [String]()
    var databaseRef: DatabaseReference!
    let postRef = Firestore.firestore().collection("Rooms")
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 129/255, blue: 124/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        roomNameLabel.layer.cornerRadius = 5
        roomNameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomNameLabel.layer.shadowColor = UIColor.black.cgColor
        roomNameLabel.layer.shadowOpacity = 0.6
        roomNameLabel.layer.shadowRadius = 4
        
        
        roomPasswordLabel.layer.cornerRadius = 5
        roomPasswordLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        roomPasswordLabel.layer.shadowColor = UIColor.black.cgColor
        roomPasswordLabel.layer.shadowOpacity = 0.6
        roomPasswordLabel.layer.shadowRadius = 4
        
        leaveRoomButton.layer.cornerRadius = 5
        leaveRoomButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        leaveRoomButton.layer.shadowColor = UIColor.black.cgColor
        leaveRoomButton.layer.shadowOpacity = 0.6
        leaveRoomButton.layer.shadowRadius = 4
        
       
        roomNameLabel.text = "ルーム名は\(roomName)"
        roomPasswordLabel.text = "パスワードは\(roomPassword)"
        
        print("パスワードは\(roomPassword)")

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var leaveRoomButton: UIButton!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomPasswordLabel: UILabel!
    
    
    
    
    @IBAction func leaveRoomButton(_ sender: Any) {
        //FireStoreから削除
        postRef.document(password).delete()
        //UserDefaultから削除
        joinedRoomName = (userDefaults.array(forKey: "name") ?? [""]) as [String]
        joinedRoomPassword = (userDefaults.array(forKey: "password") ?? [""]) as [String]
        joinedRoomName.remove(value: self.roomName)
        joinedRoomPassword.remove(value: self.roomPassword)
        
        self.userDefaults.set(joinedRoomName, forKey: "name")
        self.userDefaults.set(joinedRoomPassword, forKey: "password")
        
        let index = navigationController!.viewControllers.count - 3
        navigationController?.popToViewController(navigationController!.viewControllers[index], animated: true)
    }
    
    
   

}
//配列から要素を指定して削除
extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.index(of: value) {
            self.remove(at: i)
        }
    }
}
