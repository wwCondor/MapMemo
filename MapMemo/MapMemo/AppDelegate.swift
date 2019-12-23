//
//  AppDelegate.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager?
    var notificationCenter: UNUserNotificationCenter!
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        locationManager = CLLocationManager()
//        locationManager!.delegate = self
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        
        let notificationsManager = NotificationManager.shared
//        notificationsManager.notificationCenter.delegate = notificationsManager
        notificationsManager.requestNotificationAuthorization()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = UIColor(named: .objectColor) // Bar background color
        navigationBarAppearance.tintColor = UIColor(named: .tintColor) // Tintcolor text and icons
        navigationBarAppearance.isTranslucent = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainController())
        
        return true
    }
    
    func handleNotification(for region: CLRegion) {
//    func handleNotification(notificationText: String, didEnter: Bool, for region: CLRegion) {
        guard let reminder = managedObjectContext.fetchReminder(with: region.identifier, context: managedObjectContext) else {
            // We end up here when if we can't fetch reminder
            if UIApplication.shared.applicationState == .active {
                presentAlert(description: ReminderError.fetchReminder.localizedDescription)
            }
            print("This did not work")
            return
        }
        
        if UIApplication.shared.applicationState == .active {
            presentAlert(description: "\(reminder.locationName): \(reminder.message)")
            if reminder.isRepeating == false {
                // In here we want to stop monitoring the reminder
                let region = locationManager?.monitoredRegions.first { $0.identifier == reminder.locationName }
                guard let regionToStopMonitoring = region else { return }
                locationManager?.stopMonitoring(for: regionToStopMonitoring)
            }
        } else {
            
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // This sets the badge number to 0
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack
    // NSManagedObjectContext: Object used to manipulate and track changes to managed objects.
    lazy var managedObjectContext: NSManagedObjectContext = {
        let container = self.persistentContainer
        return container.viewContext
    }()

    // NSPersistentContainer: Container that encapsulates the CoreData stack in your app.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MapMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension NSManagedObjectContext {
    func saveChanges() {
        if self.hasChanges {
            do {
                try save()
            } catch {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchReminder(with locationName: String, context: NSManagedObjectContext) -> Reminder? {
        
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        request.predicate = NSPredicate(format: "locationName == %@", locationName)
        
        do {
            let reminders = try context.fetch(request)
            return reminders.first
        } catch {
            // Inform User Reminder could not be retrieved?
            print("Could not fetch reminder by location name, error: \(error.localizedDescription)")
            return nil
        }
    }}

extension AppDelegate: CLLocationManagerDelegate {
    // Called when region is entered
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        handleNotification(for: region)
//        handleNotification(notificationText: "Arrived at: \(region.identifier) region", didEnter: true, for: region)
    }
    
    // Called when region is exited
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        handleNotification(for: region)
//        handleNotification(notificationText: "Left: \(region.identifier) region", didEnter: false, for: region)
    }
}

// MARK: Notification Center Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // Enables notifications even if application is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    // MARK: Extra Feature?
    // When user taps notification we could direct user to center of region
    // Idea: If user agrees we could have another "compass" that instead of pointing north points to location center
    // This enables a response to the notification
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let request = response.notification.request
//
//        guard let reminder = managedObjectContext.fetchReminder(with: request.identifier, context: managedObjectContext) else {
//            if UIApplication.shared.applicationState == .active {
//                presentAlert(description: ReminderError.fetchReminder.localizedDescription)
//            }
//            print("This other thing did not work")
//            completionHandler()
//            return
//        }
//
//        handleNotification(for: reminder)
//
//        completionHandler()
//    }
}

extension AppDelegate {
    func presentAlert(description: String) {
        // Alert
        let alert = UIAlertController(title: nil, message: description, preferredStyle: .alert)
        
        let confirmation = UIAlertAction(title: "OK", style: .default) {
            (action) in alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(confirmation)
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens

        if let window = window {
            window.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
//    func presentFailedPermissionActionSheet(description: String) {
//        // Actionsheet
//        let actionSheet = UIAlertController(title: nil, message: description, preferredStyle: .actionSheet)
//
//        actionSheet.addAction(UIAlertAction(title: "Ok, take me to Settings", style: .default, handler: { (action) in
//            if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
//                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
//            }
//        }))
//
//        actionSheet.addAction(UIAlertAction(title: "Thanks, but I'll go to settings later", style: .cancel, handler: { (action) in
//
//        }))
//
//        let window = UIApplication.shared.windows.first { $0.isKeyWindow } // handles deprecated warning for multiple screens
//
//        if let window = window {
//            window.rootViewController?.present(actionSheet, animated: true, completion: nil)
//        }
//    }
}
