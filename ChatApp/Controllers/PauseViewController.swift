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
    var messageArrayForDelete = [String]()
    var databaseRef: DatabaseReference!
    let postRef = Firestore.firestore().collection("Rooms")
    override func viewDidLoad() {
        super.viewDidLoad()
        roomNameLabel.text = "ルーム名は\(roomName)"
        roomPasswordLabel.text = "パスワードは\(roomPassword)"
        
        print("パスワードは\(roomPassword)")

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var roomPasswordLabel: UILabel!
    @IBAction func roomDisbandButton(_ sender: Any) {
        
        
        for documentId in messageArrayForDelete {
            messageDocumentDelete(documentId)
        }//メッセージドキュメントを削除
        postRef.document(roomPassword).delete()//チャットルームドキュメントを削除
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func leaveRoomButton(_ sender: Any) {
        for documentId in messageArrayForDelete {
            messageDocumentDelete(documentId)
        }
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func messageDocumentDelete (_ documentId: String) {
        postRef.document(roomPassword).collection("messages").document(documentId).delete()
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
