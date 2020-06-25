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
    var textFieldCount = Bool()
    var messageArrayForDelete = [String]()
    var databaseRef: DatabaseReference!
    let postRef = Firestore.firestore().collection("Rooms")
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.layer.cornerRadius = 100
        //roomNameLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //roomNameLabel.layer.shadowColor = UIColor.black.cgColor
        //roomNameLabel.layer.shadowOpacity = 0.6
        //roomNameLabel.layer.shadowRadius = 4
        
        
        roomPasswordLabel.layer.cornerRadius = 100
        roomPasswordLabel.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //roomPasswordLabel.layer.shadowColor = UIColor.black.cgColor
        //roomPasswordLabel.layer.shadowOpacity = 0.6
        //roomPasswordLabel.layer.shadowRadius = 4
        
        leaveRoomButton.layer.cornerRadius = 25
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
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
   

}
