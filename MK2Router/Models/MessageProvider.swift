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
    
    private init() {
    }
    
    func sendMessage(message: Message, handler: () -> Void) {
        let notification = UILocalNotification()
        
        notification.fireDate = NSDate(timeIntervalSinceNow: 5)
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(message.title)へのメッセージが送信されました！"
        notification.userInfo = ["itemID": message.itemID]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        handler()
    }
}
