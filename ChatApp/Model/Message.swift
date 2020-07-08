//
//  Message.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/21.
//  Copyright © 2020 大塚周. All rights reserved.
//

import Foundation
import Firebase
class StoredMessage {
    let message: String
    let sender: String
    var time: Timestamp
    init(dic: [String: Any]) {
        self.message = dic["message"] as? String ?? ""
        self.sender = dic["sender"] as? String ?? ""
        self.time = dic["time"] as? Timestamp ?? Timestamp()
    }
}

//let docData = [
//"message": text,
//"sender": userId,
//"time": Timestamp()
//] as [String : Any] と合わせている
