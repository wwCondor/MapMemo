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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    let localNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let notifications = NotificationManager.shared
        notifications.notificationCenter.delegate = notifications
        notifications.requestNotificationAuthorization()
    
//        notifications.notificationCenter.delegate = notifications
        
//        localNotificationCenter.delegate = self
        
        let navigationBarAppearance = UINavigationBar.appearance()
        
//        requestAuthorization()
        
//        createLocalNotification(notificationType: "Whatever")

        navigationBarAppearance.barTintColor = ColorSet.objectColor // Bar background color
        navigationBarAppearance.tintColor = ColorSet.tintColor // Tintcolor text and icons
        navigationBarAppearance.isTranslucent = false
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainController())
        
        return true
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
}
