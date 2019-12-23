//
//  MainController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit
import CoreData
import CoreLocation
import UserNotifications

class MainController: UIViewController {
    
    let updateRemindersNotificationKey = Notification.Name(rawValue: Key.updateReminderNotification)
    
    let reminderController = ReminderController()
    let activeReminderController = ActiveRemindersController()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var reminders: [Reminder] = []
    
    private func getActiveReminders() {
        do {
            reminders = try managedObjectContext.fetch(NSFetchRequest(entityName: "Reminder"))
        } catch {
            presentAlert(description: ReminderError.unableToFetchActiveReminders.localizedDescription, viewController: self)
        }
        print(reminders)
    }
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private let locationManager = CLLocationManager()
    var locationAuthorized: Bool = false
    var lastLocation: CLLocation?
    
    let regionInMeters: Double = 2500 // This is how zoomed in the map is around user
    
    lazy var memoMap: MKMapView = {
        let memoMap = MKMapView()
        memoMap.overrideUserInterfaceStyle = .dark
        memoMap.isUserInteractionEnabled = true
        memoMap.isZoomEnabled = true
        memoMap.translatesAutoresizingMaskIntoConstraints = false
        return memoMap
    }()
    
    lazy var compass: UIImageView = {
        let image = UIImage(named: Icon.compassIcon.name)?.withRenderingMode(.alwaysTemplate)
        let compass = UIImageView(image: image)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.backgroundColor = .clear
        compass.tintColor = UIColor(named: .tintColor)
        compass.alpha = 0.70
        return compass
    }()
    
    lazy var settingsShortcut: CustomButton = {
        let settingsShortcut = CustomButton(type: .custom)
        settingsShortcut.backgroundColor = UIColor.clear
        settingsShortcut.alpha = 0
        let image = UIImage(named: Icon.settingsIcon.name)?.withRenderingMode(.alwaysTemplate)
        settingsShortcut.setImage(image, for: .normal)
        let inset: CGFloat = 15
        settingsShortcut.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        settingsShortcut.addTarget(self, action: #selector(launchSettings(sender:)), for: .touchUpInside)
        return settingsShortcut
    }()
    
    lazy var addButton: CustomButton = {
        let addButton = CustomButton(type: .custom)
        addButton.alpha = 0.85
        let image = UIImage(named: Icon.addIcon.name)?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        let inset: CGFloat = 15
        addButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        addButton.addTarget(self, action: #selector(presentReminderController(sender:)), for: .touchUpInside)
        return addButton
    }()
    
    lazy var activeRemindersButton: CustomButton = {
        let activeRemindersButton = CustomButton(type: .custom)
        let sortImage = UIImage(named: Icon.activeReminderIcon.name)!.withRenderingMode(.alwaysTemplate)
        activeRemindersButton.setImage(sortImage, for: .normal)
        let inset: CGFloat = 2
        activeRemindersButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset)
        activeRemindersButton.addTarget(self, action: #selector(presentActiveRemindersController), for: .touchUpInside)
        return activeRemindersButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        addObserver()
        
        getActiveReminders()

        memoMap.delegate = self
        
        view.backgroundColor = UIColor(named: .appBackgroundColor)
    
        setupView()
        setupNavigationBar()
        checkLocationServices() // Calls createReminders Indirectly
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateReminders(sender:)), name: updateRemindersNotificationKey, object: nil)
    }
    
    @objc func updateReminders(sender: NotificationCenter) {
        print("Refreshing Reminders")
        removeAllReminders()
        getActiveReminders()
        createReminders(reminders: reminders)
    }
    
    private func removeAllReminders() {
        reminders.removeAll()
        memoMap.removeOverlays(memoMap.overlays)
        memoMap.removeAnnotations(memoMap.annotations)
        let regions = locationManager.monitoredRegions
        for region in regions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    private func createAnnotation(reminder: Reminder) {
        let annotation = CustomPointAnnotation()
        annotation.title = reminder.title
        annotation.subtitle = reminder.message
        annotation.pinTintColor = UIColor(named: reminder.bubbleColor)
        annotation.coordinate = CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude)
        memoMap.addAnnotation(annotation)
    }
    
    private func createLocationBubble(reminder: Reminder) {
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude),
                              radius: reminder.bubbleRadius)
        memoMap.addOverlay(circle)
        memoMap.reloadInputViews()
    }
    
    private func createNotification(reminder: Reminder) {
        let region = CLCircularRegion.init(center: CLLocationCoordinate2D(latitude: reminder.latitude, longitude: reminder.longitude),
                                                   radius: reminder.bubbleRadius,
                                                   identifier: reminder.locationName)
        if reminder.triggerWhenEntering == true {
            region.notifyOnEntry = true
            region.notifyOnExit = false
        } else if reminder.triggerWhenEntering == false {
            region.notifyOnEntry = false
            region.notifyOnExit = true
        }
        locationManager.startMonitoring(for: region)
        
        let identifier = reminder.locationName
        let content = UNMutableNotificationContent()
        let triggerCondition = reminder.triggerWhenEntering ? "Entered" : "Exited"
        content.title = reminder.title
        content.body = "\(triggerCondition) \(reminder.locationName) bubble: \(reminder.message)"
        content.sound = UNNotificationSound.default
        let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: reminder.isRepeating)
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content,
                                            trigger: locationTrigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                if UIApplication.shared.applicationState == .active {
                    self.presentAlert(description: NotificationError.unableToAddNotificationRequest.localizedDescription, viewController: self)
                }
            }
        }
        print("Reminder added: \(reminder.title)")
    }

    private func createReminders(reminders: [Reminder]) {
        // First we check whether we actually have reminders
        if reminders.count != 0 {
            for reminder in reminders {
                // We only add the reminders that are toggled as active
                if reminder.isActive == true {
                    createAnnotation(reminder: reminder)
                    createLocationBubble(reminder: reminder)
                    createNotification(reminder: reminder)
                }
            }
        }
        print("***")
        print("Regions currently monitored: \(locationManager.monitoredRegions.count)")
        print("***")
    }
    
    private func removeNotifications() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Removed all delivered and pending notifications")
    }
    
    private func setupView() {
        view.addSubview(memoMap)
        view.addSubview(addButton)
        view.addSubview(compass)
        view.addSubview(settingsShortcut)
                        
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            addButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            memoMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoMap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoMap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            memoMap.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            compass.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.offset),
            compass.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.offset),
            compass.widthAnchor.constraint(equalToConstant: Constant.compassSize),
            compass.heightAnchor.constraint(equalToConstant: Constant.compassSize),
            
            settingsShortcut.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            settingsShortcut.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -Constant.offset),
            settingsShortcut.widthAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            settingsShortcut.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let activeRemindersBarButton = UIBarButtonItem(customView: activeRemindersButton)
        self.navigationItem.leftBarButtonItem = activeRemindersBarButton
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 25
    }
    
    private func updateSettingsShortcutAccess() {
        // If we have no authorization we present the settings shortcut
        if locationAuthorized == false {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: { self.settingsShortcut.alpha = 1 },
                           completion: { _ in
                            self.addButton.isEnabled = false
                            self.activeRemindersButton.isEnabled = false
            })
        // If we have authorization we hide the settings shortcut
        } else if locationAuthorized == true {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: { self.settingsShortcut.alpha = 0 },
                           completion: { _ in
                            self.addButton.isEnabled = true
                            self.activeRemindersButton.isEnabled = true
            })
        }
    }
    
    private func checkLocationServices() {
        print("Checking Location Servives")
        if CLLocationManager.locationServicesEnabled() {
            print("Location Services are Enabled")
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            print("Location Services are Disabled")
            presentFailedPermissionActionSheet(description: AuthorizationError.locationServicesDisabled.localizedDescription , viewController: self)
        }
    }
    
    private func checkLocationAuthorization() {
        print("Checking Location Authorization")
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            print("Requesting Authorization")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationAuthorized = false
            print("Authorization restricted or denied")
            presentFailedPermissionActionSheet(description: AuthorizationError.locationAuthorizationDenied.localizedDescription , viewController: self)
        case .authorizedAlways, .authorizedWhenInUse:
            locationAuthorized = true
            print("Authorized")
            memoMap.showsUserLocation = true
            centerMapOnUserLocation()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            createReminders(reminders: reminders) // Handles the annotations, notification content and geoFence
        @unknown default:
            break
        }
        updateSettingsShortcutAccess()
    }
    
    private func centerMapOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            memoMap.setRegion(region, animated: true)
        }
    }
    
    @objc func presentReminderController(sender: Any?) {
        if reminders.count < 20 {
            print("Launching ReminderController")
            reminderController.modeSelected = .addReminderMode
            reminderController.managedObjectContext = self.managedObjectContext
            reminderController.resetReminderInfo()
            navigationController?.pushViewController(reminderController, animated: true)
        } else {
            presentAlert(description: ReminderError.maxRemindersReached.localizedDescription, viewController: self)
        }
    }

    @objc private func presentActiveRemindersController(sender: UIBarButtonItem) {
        print("Presenting ActiveRemindersController")
        activeReminderController.managedObjectContext = self.managedObjectContext
        navigationController?.pushViewController(activeReminderController, animated: true)
    }
    
    @objc private func launchSettings(sender: UIButton) {
        print("Launching Settings")
        if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Location Manager Delegate
extension MainController: CLLocationManagerDelegate {
    
    // Informs delegate of new heading. Used for updating compass image by rotating it
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.3) {
            let angle = CGFloat(newHeading.trueHeading).degreesToRadians
            self.compass.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
        }
    }
    
    // Informs delegate new location data is available and updates map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        memoMap.setRegion(region, animated: true)
    }
    
    // Gets called when authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension MainController: MKMapViewDelegate {
    // MARK: Handles Pins
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil { // This means we have no annotations we can recycle
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.isEnabled = true
            annotationView?.canShowCallout = true
        } else { // This means we can recycle an annotation
            annotationView?.annotation = annotation
        }
        if let annotation = annotation as? CustomPointAnnotation {
            annotationView?.pinTintColor = annotation.pinTintColor
        }
        
        return annotationView
    }
    
    // MARK: Handles Bubble Drawing
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let bubble  = MKCircleRenderer(overlay: overlay)
        bubble.strokeColor = UIColor(named: .objectColor)
        bubble.fillColor = UIColor(named: .objectColor)!.withAlphaComponent(0.2)
        bubble.lineWidth = 2
        return bubble
    }
}

class CustomPointAnnotation: MKPointAnnotation {
    var pinTintColor: UIColor?
}

