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
    
    var notificationAuthorizationApproved: Bool = false
    var locationAuthorizationApproved: Bool = false
    
    private let locationManager = CLLocationManager()
    
    static let shared = LocationNotificationManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func createLocalNotification(notificationInfo: MapMemoStub) { //}(notificationType: String) {
        let content = UNMutableNotificationContent()
        
        let userActions = "User Actions"
        
        //        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger) // Schedule the notification.
        
//        let date = Date(timeIntervalSinceNow: 15)
//        let triggerDate = Calendar.current.dateComponents([.second], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        content.title = notificationInfo.title
        content.body = notificationInfo.body
        content.sound = .default
//        content.badge = 1
        
        content.categoryIdentifier = userActions
        content.launchImageName = Icon.activeReminderIcon.name
        //        content.
        //        UNNotificationRequest.localNotification
        
        let ignoreAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let showMapAction = UNNotificationAction(identifier: "ShowReminder", title: "Show Reminder", options: [.foreground])
        
        //        let trigger = UNLocationNotificationTrigger(triggerWithRegion: region, repeats: false)
        
        let category = UNNotificationCategory(identifier: userActions, actions: [ignoreAction, showMapAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func destinationRegion(notificationInfo: MapMemoStub) -> CLCircularRegion {
        let lattitude = notificationInfo.coordinate.lattitude
        let longitude = notificationInfo.coordinate.longitude
                
        let destinationRegion = CLCircularRegion(center: CLLocationCoordinate2DMake(lattitude, longitude),
                                                 radius: CLLocationDistance(notificationInfo.radius),
                                                 identifier: notificationInfo.locationId)
        
        if notificationInfo.trigger == .whenEnteringRegion {
            destinationRegion.notifyOnEntry = true
            destinationRegion.notifyOnExit = false
        } else if notificationInfo.trigger == .whenLeavingRegion {
            destinationRegion.notifyOnEntry = false
            destinationRegion.notifyOnExit = true
        } else if notificationInfo.trigger == .whenEnteringAndLeavingRegion {
            destinationRegion.notifyOnEntry = true
            destinationRegion.notifyOnExit = true
        }
        
        return destinationRegion
    }

}

// MARK: NotificationCenterDelegate
extension LocationNotificationManager: UNUserNotificationCenterDelegate {
    
        // Request Authorization
        func requestNotificationAuthorization() {
            let options: UNAuthorizationOptions = [.badge, .sound, .alert]
            
            notificationCenter.requestAuthorization(options: options) { (authorizationGranted, error) in
                if authorizationGranted == false {
                    self.notificationAuthorizationApproved = false
                    print("Notification authorization declined")
                    // Inform rest of app to change UI accordingly
                } else if authorizationGranted == true {
                    print("Notification authorization granted")
                    self.notificationAuthorizationApproved = true
                }
            }
        }
        
        // Check Authorization Status
        func checkNotificationAuthorization() {
            notificationCenter.getNotificationSettings { (settings) in
                if settings.authorizationStatus != .authorized {
                    self.notificationAuthorizationApproved = false
                    print("Notification authorization declined")
                    // Notifications not allowed
                } else {
                    self.notificationAuthorizationApproved = true
                    print("Notification authorization granted")
                }
            }
        }
        

    
    
    
    
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
                print("Remind in 3 minutes") // set a timer in xx minutes to remind user
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
    func requestLocationAuthorization() {
        let authorizationStatus = CLLocationManager.authorizationStatus()

        switch authorizationStatus {
        case .notDetermined:
            // MARK: Request Location Authorization
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            // when denied we should uppdate UI to give easy access to settings with shortcut
            return
        case .authorizedAlways, .authorizedWhenInUse:
            return
        @unknown default:
            break
        }
    }
    
    
    
    func requestLocation() {
//        let connectionAvailable = Reachability.checkReachable()
//        if connectionAvailable == true {
//            locationManager.requestLocation()
//        } else if connectionAvailable == false {
//            locationLabel.text = "There is no internet connection. Reconnect, close tab and try again."
//        }
    }
    
    
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
