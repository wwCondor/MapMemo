//
//  NotificationsManager.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import CoreLocation
import UserNotifications

final class LocationNotificationManager: NSObject {
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private let locationManager = CLLocationManager()
    
    static let shared = LocationNotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    // Request Authorization
    func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        
        notificationCenter.requestAuthorization(options: options) { (authorizationGranted, error) in
            if authorizationGranted == false {
                print("User has declined authorization for notifications")
                // Inform rest of app to change UI accordingly
            }
        }
    }
    
    // Check Authorization Status
    private func checkNotificationAuthorization() {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
    }
    
    func createLocalNotification(notificationType: String) {
        let content = UNMutableNotificationContent()
        
        let userActions = "User Actions"
        
        
        //        let date = Date(timeIntervalSinceNow: 15)
        //        let triggerDate = Calendar.current.dateComponents([.second], from: date)
        //        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        content.title = notificationType
        content.body = "This is how to create a notification \(notificationType)"
        content.sound = .default
        content.badge = 1
        content.categoryIdentifier = userActions
        content.launchImageName = Icon.activeReminderIcon.name
        //        content.
        //        UNNotificationRequest.localNotification
        
        let ignoreAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let showMapAction = UNNotificationAction(identifier: "ShowMap", title: "ShowMap", options: [.foreground])

        //        let trigger = UNLocationNotificationTrigger(triggerWithRegion: region, repeats: false)
        
        let category = UNNotificationCategory(identifier: userActions, actions: [ignoreAction, showMapAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
}

// MARK: NotificationCenterDelegate
extension LocationNotificationManager: UNUserNotificationCenterDelegate {
    // Enables notifications even if application is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    // When user taps notification app opens by default
    // This enables a response to the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == "Local Notification" {
            switch response.actionIdentifier {
            case "Snooze":
                print("Reminding in 5 minutes") // set a timer in xx minutes to remind user
            case "ShowMap":
                print("Show map and some message label") // center map on user and show message label
            default:
                print("Unknown action")
            }
            // Here we do something, for example:
            // 1. Display reminder message on map
            // 2. Center map on current position
            print("Handling notifications with the local notificaiton identifier")
        }
        completionHandler()
    }
}


extension LocationNotificationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Gets called when status changes
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        // Do something when user enters region
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        // Do something when user leaves region
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // informs delegate one or more beacons are in ranges
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Informs delegate new location data is available
    }
    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        // Informs delegate that a beacon satisfying the constraints has been
    }
}
