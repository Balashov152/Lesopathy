//
//  PushMessage.swift
//  PickMeUp
//
//  Created by Sergey on 05.09.2018.
//  Copyright © 2018 MediaStreamGroup. All rights reserved.
//

import UserNotifications

/* property in super class
 open var attachments: [UNNotificationAttachment]
 @NSCopying open var badge: NSNumber?
 open var body: String
 open var categoryIdentifier: String
 open var launchImageName: String
 @NSCopying open var sound: UNNotificationSound?
 open var subtitle: String
 open var threadIdentifier: String
 open var title: String
 open var userInfo: [AnyHashable : Any]
 */

class PushMessage: UNMutableNotificationContent {
    
    convenience init(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        self.init(category: content)
    }
    
    convenience init(category: UNNotificationContent) {
        self.init()
        attachments = category.attachments
        badge = category.badge
        categoryIdentifier = category.categoryIdentifier
        launchImageName = category.launchImageName
        sound = category.sound
        subtitle = category.subtitle
        threadIdentifier = category.threadIdentifier
        title = category.title
        userInfo = category.userInfo
    }

    override init() {
        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
