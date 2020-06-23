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
    
    var messageArrayForDelete = [String]()
    var senderId = ""
    
    let currentUser = Sender(senderId: "self")
    
    let otherUser = Sender(senderId: "other")
    
    var roomPassword = ""
    var roomName = ""
    var messages = [MessageType]()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        let testSwiftUI = UIHostingController(rootView:
            ChatRoomBar()
        )
        self.addChild(testSwiftUI)
        self.view.addSubview(testSwiftUI.view)
        testSwiftUI.didMove(toParent: self)
        
        testSwiftUI.view.translatesAutoresizingMaskIntoConstraints = false
        
        testSwiftUI.view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //frameの底からのY座標
        testSwiftUI.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        //右からのpaddingをどれだけ取るか
        testSwiftUI.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        //左からのpaddingをどれだけ取るか
        //testSwiftUI.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        //画面したからframeのY座標
        testSwiftUI.view.backgroundColor = .clear
        userId = UIDevice.current.identifierForVendor!.uuidString
        print("パスワードは\(roomPassword)")
        //self.bring

        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
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
        
        
        fetchMessage()
        // Do any additional setup after loading the view.
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
    @objc func pause() {
        performSegue(withIdentifier: "pause", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? PauseViewController
        nextVC?.roomPassword = self.roomPassword
        nextVC?.roomName = self.roomName
        nextVC?.messageArrayForDelete = self.messageArrayForDelete
    }
    
    override func viewDidLayoutSubviews() {
        
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
    
    private func fetchMessage() {
        postRef.document(roomPassword).collection("messages").addSnapshotListener{ (snapshots, err) in
            
            if let err = err {
                print("メッセージ情報の取得に失敗しました。\(err)")
                return
            }
            snapshots?.documentChanges.forEach( { (DocumentChange) in
                switch DocumentChange.type {
                    
                case .added:
                    print("テスト .added")
                    let dic = DocumentChange.document.data()
                    let dicMessage = StoredMessage(dic: dic)
                    print(dicMessage.message)
                    print("メッセージのドキュメントデータは\(DocumentChange.document.documentID)です")
                    //メッセージのドキュメントを取得し、格納
                    //userIdが一致しない時senderをOtherUserにする
                    self.messageArrayForDelete.append(DocumentChange.document.documentID)
                    let sendertest = self.user(senderId: dicMessage.sender)
                    print(sendertest)
                    let message = Message(sender: sendertest, messageId: /*UUID().uuidString*/"1", sentDate: Date().addingTimeInterval(-16400), kind: .text(dicMessage.message))
                    
                    self.messages.append(message)
                    self.messagesCollectionView.insertSections([self.messages.count - 1])
                case .modified, .removed:
                    print("nothing to do")
                }
                }
            )
        }
    }
    
    func user(senderId: String) -> Sender {
        if senderId == self.userId {
            
            return currentUser
        } else {
           
            return otherUser
        }
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

//ホームボタン、スクリーンショットの検出
extension ChatViewController {
    
    
    @objc func didTakeScreenshot() {
        inputMessage(text: "スクリーンショットが保存されました")
    }
    @objc func didHomebuttonTapped() {
        print("ホームボタン")
    }
        
    
}

