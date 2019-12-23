//
//  NotificationsManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import CoreLocation
import UserNotifications

final class NotificationManager: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    static let shared = NotificationManager()

    var notificationAuthorized: Bool = false
    
    // Request Authorization
    func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        
        notificationCenter.requestAuthorization(options: options) { (authorizationGranted, error) in
            print("Reqesting authorization")
            if authorizationGranted == false {
                self.notificationAuthorized = false
                print("Notification authorization declined")
            } else if authorizationGranted == true {
                print("Notification authorization granted")
                self.notificationAuthorized = true
            }
        }
    }
    
    // Check Authorization Status
    func checkNotificationAuthorization() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Checking Notification Authorization")
            if settings.authorizationStatus != .authorized {
                self.notificationAuthorized = false
                print("Notification authorization declined")
            } else {
                self.notificationAuthorized = true
                print("Notification authorization granted")
            }
        }
    }
}
