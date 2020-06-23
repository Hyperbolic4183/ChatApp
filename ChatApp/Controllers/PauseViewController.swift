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
        
NotificationCenter.default.addObserver(self, selector: #selector(willTerminate), name: UIApplication.willTerminateNotification, object: nil)
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
    
    
    
    private func messageDocumentDelete (_ documentId: String) {
        postRef.document(roomPassword).collection("messages").document(documentId).delete()
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @objc func willTerminate() {
      //  inputMessage(text: "テスト")
//        for documentId in messageArrayForDelete {
//            messageDocumentDelete(documentId)
//        }//メッセージドキュメントを削除
      //  postRef.document(roomPassword).delete()//チャットルームドキュメントを削除
       print("アプリが閉じられました。aa")
    }
    private func inputMessage(text: String) {
        let messageId = randomString(length: 20)
        let docData = [
            "message": text,
            "sender": UIDevice.current.identifierForVendor!.uuidString,
            "time": Timestamp()
            ] as [String : Any]
        postRef.document(roomPassword).collection("messages").document(messageId).setData(docData) {(err) in
        if let err = err {
            print("メッセージ情報の保存に失敗しました。\(err)")
            return
        }
            //self.messageArrayForDelete.append(messageId)
            print("格納したメッセージIdは\(messageId)です")
            print("メッセージが保存されました")
            
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
