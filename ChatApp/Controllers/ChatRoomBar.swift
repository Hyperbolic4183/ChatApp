//
//  ChatRoomBar.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/22.
//  Copyright © 2020 大塚周. All rights reserved.
//

import SwiftUI
let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height
struct ChatRoomBar: View {
    var body: some View {
        
            
            HStack {
                Button(action: {print("SwiftUIButton tapped")}) {
                    Image(systemName: "arrow.turn.up.left")
                }
                Spacer()
            
            Text("")
                .background(Color.clear)
                Spacer()
        }.background(Color.clear)
            .frame(width: width, height: 50)
            
    }
}

struct ChatRoomBar_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomBar()
    }
}
