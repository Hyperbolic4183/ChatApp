//
//  ChatViewController.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/18.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MessageKit
import InputBarAccessoryView
import SwiftUI

struct Sender: SenderType {
    var senderId: String
}


struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
}


class storedMessage {
    let sender: String
    let message: String
    init(dic: [String: Any]) {
        self.sender = dic["sender"] as? String ?? ""
        self.message = dic["message"] as? String ?? ""
    }
}



class ChatViewController: MessagesViewController, MessagesDataSource,MessagesLayoutDelegate, MessagesDisplayDelegate {
    var userDefaults = UserDefaults.standard
    
    var userDefaultsRoomNameArray = [String]()

    let width = UIScreen.main.bounds.size.width
    let height = UIScreen.main.bounds.size.height
    var databaseRef: DatabaseReference!
    var ref = Database.database().reference()
    let postRef = Firestore.firestore().collection("Rooms")
    var userId = String()
    var storedMessageCount = 0
    var messageArray: [String: Any] = [:]
    var messageData = [
         "user" : String(),
         "message": String()
    ] as [String : Any]
    
    var messageArrayForDelete: [String] = []
    var senderId = ""
    
    let currentUser = Sender(senderId: "self")
    
    let otherUser = Sender(senderId: "other")
    
    var password = ""
    var roomName = ""
    var roomPassword = ""
    var messages = [MessageType]()
   
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        
        navigationItem.title = roomName
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 129/255, blue: 124/255, alpha: 0.5)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        userId = UIDevice.current.identifierForVendor!.uuidString
        
        print("パスワードは\(password)")
        print("ルーム名は\(roomName)")
        print("ルームのパスワードは\(roomPassword)")
        //self.bring

        

        
        NotificationCenter.default.addObserver(self, selector: #selector(pause), name: .notifyName, object: nil)
        
        scrollsToBottomOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self

        if let layout = self.messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
             //自分のアイコンを非表示
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.zero)

            // 非表示の分、吹き出しを移動して空白を埋める
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            layout.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: insets))
            layout.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: insets))
            layout.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: insets))
        }
        
        fetchMessage(text: password)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.removeObserver(self,name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIScreen.capturedDidChangeNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear\(password)")
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didCapturedScreen),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        
    }
    
    
    func currentSender() -> SenderType {
        return currentUser//senderを決定する
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(corner, .curved)
    }
    
    //ホームボタンが押された時に遷移する
    @objc private func pause() {
       performSegue(withIdentifier: "home", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? PauseViewController
        nextVC?.roomPassword = self.roomPassword
        nextVC?.roomName = self.roomName
        nextVC?.password = self.password
        
        let beforeVC = segue.destination as? JoinedRoomViewController
        beforeVC?.password = ""
    }
    
    


}
extension ChatViewController: MessageCellDelegate, InputBarAccessoryViewDelegate{
    
    
    
    
    //send
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
   
        inputMessage(text: inputBar.inputTextView.text)
  
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToBottom()
        return
      
    }
    
    func fetchMessage(text: String) {
        print("テストドキュメント名は\(text)")
        postRef.document(text).collection("messages").addSnapshotListener{ (snapshots, err) in
            
            if let err = err {
                print("メッセージ情報の取得に失敗しました。\(err)")
                return
            }
            
            
            snapshots?.documentChanges.forEach( { (DocumentChange) in
                switch DocumentChange.type {
                case .added:
                    let dic = DocumentChange.document.data()
                    let dicMessage = StoredMessage(dic: dic)
                    
                    //メッセージのドキュメントを取得し、格納
                    //userIdが一致しない時senderをOtherUserにする
                    self.messageArrayForDelete.append(DocumentChange.document.documentID)
                    let sendertest = self.user(senderId: dicMessage.sender)
                    //Timestamp型をDate型に変換
                    let dateValue = dicMessage.time.dateValue()
                    let message = Message(sender: sendertest, messageId: self.randomString(length: 20), sentDate: dateValue, kind: .text(dicMessage.message))
                    print("message.sentDate\(message.sentDate)")
                    self.messages.append(message)
                    
                    self.messages = self.messages.sorted(by: { (m1,m2) in
                        return m1.sentDate < m2.sentDate
                    })
                    self.messagesCollectionView.reloadData()
                    DispatchQueue.main.async {
                    self.messagesCollectionView.scrollToBottom()
                    }
                case .modified, .removed:
                    print("nothing to do")
                }
                }
            ) }
       
    }
    
    
    
    func user(senderId: String) -> Sender {
        if senderId == self.userId {
            
            return currentUser
        } else {
           
            return otherUser
        }
    }
    
    private func inputMessage(text: String) {
        print("input:\(password)")
        let messageId = randomString(length: 20)
        let docData = [
            "message": text,
            "sender": UIDevice.current.identifierForVendor!.uuidString,
            "time": Timestamp()
            ] as [String : Any]
        postRef.document(password).collection("messages").document(messageId).setData(docData) {(err) in
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

//ホームボタン、スクリーンショットの検出
extension ChatViewController {
    
    
    @objc func didTakeScreenshot() {
        //画面のパスワードと一致した場合のみ送信
        print("スクリーンショットを保存しました(自動送信)")
        inputMessage(text: "スクリーンショットを保存しました(自動送信)")
    }
    @objc func didCapturedScreen() {
        print("画面を録画しました。(自動送信)")
        inputMessage(text: "画面を録画しました。(自動送信)")
    }
}

