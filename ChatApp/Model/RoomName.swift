//
//  Realm.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/07/06.
//  Copyright © 2020 大塚周. All rights reserved.
//

import RealmSwift

class RoomName: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var roomName: String = ""
    
    @objc dynamic var roomPassword = ""
 
}
