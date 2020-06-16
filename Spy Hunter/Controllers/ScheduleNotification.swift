//
//  ScheduleNotification.swift
//  Spy Hunter
//
//  Created by Roman Kavinskyi on 13.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
class ScheduleNotification {
    let names = StringFiles()
    
    let notificationCenter = UNUserNotificationCenter.current()

    func scheduledNotification(notificationType: String, time: Double) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
         let content = UNMutableNotificationContent() // notification content
         
         content.title = notificationType
        content.body = names.discussionIsOver
         content.sound = UNNotificationSound.default
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if let error = error {
                print(error)
            }
        }
     }
}
