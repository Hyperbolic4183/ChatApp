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
import FirebaseAuth
import MessageKit
import InputBarAccessoryView


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
    
    
    var usernumber = ""
    var password = ""
    var roomName = ""
    var roomPassword = ""
    var messages = [MessageType]()
    var filteringBool = Bool()
    var messageArrayforDelete:[String] = []
    let currentUser = Sender(senderId: "self")
    var blockUserArray: [String] = []
    let otherUser = Sender(senderId: "other")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        overrideUserInterfaceStyle = .light
        
        navigationItem.title = roomName
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 24/255, green: 129/255, blue: 124/255, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        userId = Auth.auth().currentUser?.uid as! String//UIDevice.current.identifierForVendor!.uuidString
        
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
        usernumber = String(userDefaults.integer(forKey: "usernumber"))
        print("viewWillAppear\(password)")
            //スクショ・録画の監視をオフにする
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didCapturedScreen),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        print("filteringBoolは\(filteringBool)")
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
//    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = String(userDefaults.integer(forKey: "usernumber"))
//
//        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
//        NSAttributedString.Key.foregroundColor: UIColor.darkGray])
//    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
        let indexPath = messagesCollectionView.indexPath(for: cell)![0]
        print("indexPathは\(indexPath)")
        print("documentは\(messageArrayForDelete[indexPath])")
        print(messageArrayForDelete)
        let alert: UIAlertController = UIAlertController(title: "警告", message: "ブロックしたユーザーからメッセージは届きません。", preferredStyle:  UIAlertController.Style.actionSheet)

        
        let blockAction: UIAlertAction = UIAlertAction(title: "ブロックする", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
         print("blocked")
            
            var document = self.messageArrayForDelete[indexPath]
            
            self.postRef.document(self.password).collection("messages").document(document).getDocument{ ( document, error ) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    let dicMessage = StoredMessage(dic: dataDescription ?? ["":""])
                    print(dicMessage.sender)
                    self.blockUserArray = self.userDefaults.array(forKey: "block") as? [String] ?? []
                    self.blockUserArray.append(dicMessage.sender)
                    self.userDefaults.set(self.blockUserArray, forKey: "block")
                    print("ブロックリストの数は\(self.blockUserArray)")
                   // blockUserArray.append(dicMessage.sender)
                } else {
                    print("Document does not exist")
                }
            }
            self.messageAlert(title: "ブロックしました", message: "")
            
        })
           // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
               // ボタンが押された時の処理を書く（クロージャ実装）
               (action: UIAlertAction!) -> Void in
               print("Cancel")
           })

           alert.addAction(cancelAction)
         //  alert.addAction(reportAction)
           alert.addAction(blockAction)

        present(alert, animated: true, completion: nil)
    
    }
    var alertController: UIAlertController!
    func messageAlert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                       style: .default,
                                       handler: nil))
        present(alertController, animated: true)
    }
    
//    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let dateString = formatter.string(from: message.sentDate)
//        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
//    }
    //ホームボタンが押された時に遷移する
    @objc private func pause() {
       performSegue(withIdentifier: "home", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? PauseViewController
        nextVC?.roomPassword = self.roomPassword
        nextVC?.roomName = self.roomName
        nextVC?.password = self.password
        nextVC?.filteringBool = self.filteringBool
        let beforeVC = segue.destination as? JoinedRoomViewController
        beforeVC?.password = ""
    }
    
    


}
extension ChatViewController: MessageCellDelegate, InputBarAccessoryViewDelegate{
    
    
    
    
    //メッセージを送信
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
                    print("senderは\(dicMessage.sender)")
                    let sendertest = self.user(senderId: dicMessage.sender)
                    print("sendertestは\(sendertest)")//"self"
                    //senderがブロックリストに格納されていた場合、表示しない
                    if self.checkBlock(dicMessage.sender) {
                        
                        break
                    }
                    
                    self.messageArrayForDelete.append(DocumentChange.document.documentID)
                    
                    //Timestamp型をDate型に変換
                    let dateValue = dicMessage.time.dateValue()
                    
                    let message = Message(sender: sendertest, messageId: self.usernumber, sentDate: dateValue, kind: .text(dicMessage.message))
                    print("message.sentDate\(message.sentDate)")
                    self.messages.append(message)
                    
                    self.messages = self.messages.sorted(by: { (m1,m2) in
                        return m1.sentDate < m2.sentDate
                    })
                    self.messageArrayForDelete.map({Int($0)})
                    self.messageArrayForDelete = self.messageArrayForDelete.sorted(by: { (m1,m2) in
                        return m1 < m2
                    })
                    self.messagesCollectionView.reloadData()
                    for i in 0 ..< self.messages.count {
                        print(self.messages[i])
                    }
                    
                    DispatchQueue.main.async {
                    self.messagesCollectionView.scrollToBottom()
                    }
                case .modified, .removed:
                    print("nothing to do")
                }
                }
            ) }
       
    }
    
    //senderIdがブロックリストに存在しないかチェックする
    func checkBlock(_ checkSender: String) -> Bool {
        var blockUserArray = self.userDefaults.array(forKey: "block") as? [String] ?? []
        for blockedUser in blockUserArray {
            if checkSender == blockedUser {
                print("含まれている")
                return true
            }
        }
        print("含まれていない")
        return false
    }
    
     //userIdが一致しない時senderをOtherUserにする
    func user(senderId: String) -> Sender {
        
        
        
        if senderId == self.userId {

            return currentUser
        } else {

            return otherUser
        }
        
    }
    
    private func inputMessage(text: String) {
        var usernumber = userDefaults.integer(forKey: "usernumber")
        print("input:\(password)")
        let messageId = timeNumberDocument()
        let docData = [
            "message": text,
            "sender": Auth.auth().currentUser?.uid,
            "time": Timestamp(),
            "usernumber": usernumber
            ] as [String : Any]
        postRef.document(password).collection("messages").document(messageId).setData(docData) {(err) in
        if let err = err {
            print("メッセージ情報の保存に失敗しました。\(err)")
            return
        }
            
        }
    }
    func timeNumberDocument() -> String {
        let dt = Date()
        var firstCha = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyMMddHHmmss", options: 0, locale: Locale(identifier: "ja_JP"))
        var time = dateFormatter.string(from: dt)
        var timeNumber = time.compactMap { $0.hexDigitValue }.map({String($0)})
        for cha in timeNumber {
            var cha = cha
            firstCha += cha
        }
        return firstCha ?? ""
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

