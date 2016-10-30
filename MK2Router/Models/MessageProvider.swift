//
//  MessageProvider.swift
//  MK2Router
//
//  Created by k2o on 2016/05/15.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class MessageProvider {
    static let shared: MessageProvider = MessageProvider()
    
    fileprivate init() {
    }
    
    func sendMessage(_ message: Message, delay: TimeInterval, handler: () -> Void) {
        let notification = UILocalNotification()
        
        notification.fireDate = Date(timeIntervalSinceNow: delay)
        notification.timeZone = TimeZone.current
        notification.alertBody = "\(message.title)へのメッセージが送信されました！"
        notification.userInfo = ["itemID": message.itemID]
        
        UIApplication.shared.scheduleLocalNotification(notification)
        
        handler()
    }
}
