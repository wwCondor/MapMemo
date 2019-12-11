//
//  MainController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController {
    
    let addReminderController = AddReminderController()
    let editReminderController = EditReminderController()
    let activeReminderController = ActiveRemindersController()
    
    private let locationManager = CLLocationManager()
    
    var lastLocation: CLLocation?

//    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let notificationManager = NotificationManager.shared//.notificationCenter
    
    lazy var memoMap: MKMapView = {
        let memoMap = MKMapView()
        memoMap.overrideUserInterfaceStyle = .dark
        memoMap.isUserInteractionEnabled = true
        memoMap.isZoomEnabled = true
//        memoMap.isUserLocationVisible
        memoMap.translatesAutoresizingMaskIntoConstraints = false
        return memoMap
    }()
    
    lazy var compass: UIImageView = {
        let image = UIImage(named: Icon.compassIcon.name)?.withRenderingMode(.alwaysTemplate)
        let compass = UIImageView(image: image)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.backgroundColor = UIColor.clear
        compass.tintColor = ColorSet.objectColor
        compass.alpha = 0.8
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
        
        updateSettingsShortcutAccess()

        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
        view.backgroundColor = ColorSet.appBackgroundColor
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.addSubview(addButton)
        view.addSubview(memoMap)
        view.addSubview(compass)
        view.addSubview(settingsShortcut)
        
        let offset: CGFloat = 15
                
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            addButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            memoMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            memoMap.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoMap.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            memoMap.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            
            compass.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: offset),
            compass.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: offset),
            compass.widthAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            compass.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            
            settingsShortcut.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -offset),
            settingsShortcut.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -offset),
            settingsShortcut.widthAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            settingsShortcut.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let activeRemindersBarButton = UIBarButtonItem(customView: activeRemindersButton)
        self.navigationItem.leftBarButtonItem = activeRemindersBarButton
    }
    
    // MARK: Needs testing
    private func updateSettingsShortcutAccess() {
        // If we have no authorization we present the settings shortcut
        if notificationManager.locationAuthorizationApproved == false {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: { self.settingsShortcut.alpha = 1 },
                           completion: { _ in
                            self.addButton.isEnabled = false
                            self.activeRemindersButton.isEnabled = false
            })
        // If we have authorization we hide the settings shortcut
        } else if notificationManager.locationAuthorizationApproved == true {
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: { self.settingsShortcut.alpha = 0 },
                           completion: { _ in
                            self.addButton.isEnabled = false
                            self.activeRemindersButton.isEnabled = false
            })
        }
    }
    
    @objc func presentReminderController(sender: Any?) {
        print("Launching ReminderController")
        navigationController?.pushViewController(addReminderController, animated: true)
    }

    @objc private func presentActiveRemindersController(sender: UIBarButtonItem) {
        print("Presenting ActiveRemindersController")
        navigationController?.pushViewController(activeReminderController, animated: true)
    }
    
    // MARK: Needs testing
    @objc private func launchSettings(sender: UIButton) {
        print("Launching Settings")
        if let settingsURL = URL(string: UIApplication.openSettingsURLString + Bundle.main.bundleIdentifier!) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    
    // MARK: Test
    var reminders: [MapMemoStub] = []
    
    func addReminders() {
        reminders.append(MapMemoStub.init(title: "First Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 10, trigger: .whenEnteringRegion, locationId: "LocationId1", iIsActive: false))
        reminders.append(MapMemoStub.init(title: "Second Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 20, trigger: .whenEnteringRegion, locationId: "LocationId2", iIsActive: true))
        reminders.append(MapMemoStub.init(title: "Third Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 30, trigger: .whenEnteringRegion, locationId: "LocationId3", iIsActive: false))
        reminders.append(MapMemoStub.init(title: "Fourth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 40, trigger: .whenEnteringRegion, locationId: "LocationId4", iIsActive: true))
        reminders.append(MapMemoStub.init(title: "Fifth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 50, trigger: .whenEnteringRegion, locationId: "LocationId5", iIsActive: false))
        reminders.append(MapMemoStub.init(title: "Sixth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 60, trigger: .whenEnteringRegion, locationId: "LocationId6", iIsActive: true))
        reminders.append(MapMemoStub.init(title: "Seventh Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 70, trigger: .whenEnteringRegion, locationId: "LocationId7", iIsActive: false))
        reminders.append(MapMemoStub.init(title: "Eigth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 80, trigger: .whenEnteringRegion, locationId: "LocationId8", iIsActive: true))
        reminders.append(MapMemoStub.init(title: "Ninth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 90, trigger: .whenEnteringRegion, locationId: "LocationId9", iIsActive: false))
        reminders.append(MapMemoStub.init(title: "Tenth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 100, trigger: .whenEnteringRegion, locationId: "LocationId0", iIsActive: true))
    }
}

// MARK: Location Manager Delegate
extension MainController: CLLocationManagerDelegate {
    
    // Informs delegate of new heading. Used for updating compass image by rotating it
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        UIView.animate(withDuration: 0.3) {
            let angle = newHeading.trueHeading.toRadians
            self.compass.transform = CGAffineTransform(rotationAngle: angle)
        }
    }
    
    // Informs delegate new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        lastLocation = currentLocation
    }
    
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        notificationManager.locationAuthorizationApproved = false
        // Gets called when status changes
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            notificationManager.locationAuthorizationApproved = false
            updateSettingsShortcutAccess()
            // MARK: Show settings shortcut
        case .authorizedAlways, .authorizedWhenInUse:
            notificationManager.locationAuthorizationApproved = true
            updateSettingsShortcutAccess()
        @unknown default:
            fatalError("Fatal Error. An unknown location authorization error has occurred")
        }
    }
    
    
    // MARK: Code below not used yet
    func requestLocation() {
//        let connectionAvailable = Reachability.checkReachable()
//        if connectionAvailable == true {
//            locationManager.requestLocation()
//        } else if connectionAvailable == false {
//            locationLabel.text = "There is no internet connection. Reconnect, close tab and try again."
//        }
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
    

    
    func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
        // Informs delegate that a beacon satisfying the constraints has been triggered
    }
}

