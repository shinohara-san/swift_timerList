//
//  TimerItem.swift
//  swift_timeWithUserDefault
//
//  Created by Yuki Shinohara on 2020/06/03.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import Foundation

class TimerItem: Codable {
    var title: String
    var seconds: Int
//    var timer:Timer
    
    init(title: String, seconds: Int) {
        self.title = title
        self.seconds = seconds
//        self.timer = Timer()
    }
}
