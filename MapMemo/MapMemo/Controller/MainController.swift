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
    
//    let addReminderController = AddReminderController()
    let reminderController = ReminderController()
    let activeReminderController = ActiveRemindersController()
    
    private let locationManager = CLLocationManager()
    
    var lastLocation: CLLocation?
    
    let regionInMeters: Double = 5000

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
        addButton.alpha = 0.85
        let image = UIImage(named: Icon.addIcon.name)?.withRenderingMode(.alwaysTemplate)//.alpha(1.0)
//        addButton.tintColor = ColorSet.tintColor
//        addButton.backgroundColor?.withAlphaComponent(0.9)
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
        
        memoMap.delegate = self
        
        view.backgroundColor = ColorSet.appBackgroundColor
    
        setupView()
        setupNavigationBar()
        checkLocationServices()
    }
    
    // MARK: Bubbles
    private func setupAmsterdamBubble() {
        let amsterdam = MKPointAnnotation()
        amsterdam.title = "Amsterdam"
        amsterdam.coordinate = CLLocationCoordinate2D(latitude: 52.3746569, longitude: 4.8903169)
//        memoMap.addAnnotation(amsterdam)
        addCircleAroundLocation(coordinate: amsterdam.coordinate, radius: 5000, map: memoMap)
    }
    
    func addCircleAroundLocation(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, map: MKMapView) {
        let circle = MKCircle(center: coordinate, radius: radius)
        map.addOverlay(circle)
    }
    

    
    private func setupView() {
        view.addSubview(memoMap)
        view.addSubview(addButton)
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
            memoMap.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
    
    private func setupLocationManager() {
        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 25
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
            notificationManager.locationAuthorizationApproved = false
            print("Authorization restricted or denied")
            presentFailedPermissionActionSheet(description: AuthorizationError.locationAuthorizationDenied.localizedDescription , viewController: self)
        case .authorizedAlways, .authorizedWhenInUse:
            // MARK: Do Map Stuff
            notificationManager.locationAuthorizationApproved = true
            print("Authorized")
            memoMap.showsUserLocation = true
            centerMapOnUserLocation()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            // MARK: Setup Annotations
            setupAmsterdamBubble()
            break
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
        reminderController.modeSelected = .addReminderMode
        print("Launching ReminderController")
        navigationController?.pushViewController(reminderController, animated: true)
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
        reminders.append(MapMemoStub.init(title: "First Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 10, trigger: .whenEnteringRegion, locationId: "LocationId1", iIsActive: false, regionBorderColor: .black))
        reminders.append(MapMemoStub.init(title: "Second Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 20, trigger: .whenEnteringRegion, locationId: "LocationId2", iIsActive: true, regionBorderColor: .blue))
        reminders.append(MapMemoStub.init(title: "Third Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 30, trigger: .whenEnteringRegion, locationId: "LocationId3", iIsActive: false, regionBorderColor: .green))
        reminders.append(MapMemoStub.init(title: "Fourth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 40, trigger: .whenEnteringRegion, locationId: "LocationId4", iIsActive: true, regionBorderColor: .red))
        reminders.append(MapMemoStub.init(title: "Fifth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 50, trigger: .whenEnteringRegion, locationId: "LocationId5", iIsActive: false, regionBorderColor: .yellow))
        reminders.append(MapMemoStub.init(title: "Sixth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 60, trigger: .whenEnteringRegion, locationId: "LocationId6", iIsActive: true, regionBorderColor: .black))
        reminders.append(MapMemoStub.init(title: "Seventh Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 70, trigger: .whenEnteringRegion, locationId: "LocationId7", iIsActive: false, regionBorderColor: .blue))
        reminders.append(MapMemoStub.init(title: "Eigth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 80, trigger: .whenEnteringRegion, locationId: "LocationId8", iIsActive: true, regionBorderColor: .green))
        reminders.append(MapMemoStub.init(title: "Ninth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 90, trigger: .whenEnteringRegion, locationId: "LocationId9", iIsActive: false, regionBorderColor: .red))
        reminders.append(MapMemoStub.init(title: "Tenth Reminder", body: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), radius: 100, trigger: .whenEnteringRegion, locationId: "LocationId0", iIsActive: true, regionBorderColor: .yellow))
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
    
    // MARK: Add Annotations
    func setLocationTriggerRegion() {
        
    }

    
    // MARK: Use?
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

// MARK: Annotations
extension MainController: MKMapViewDelegate {
    // This handles the pins around a location
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    // This handle the drawing of a circle around the location
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.red
            circle.fillColor = UIColor.red.withAlphaComponent(0.2)
            circle.lineWidth = 2
            return circle
        } else {
            return MKPolylineRenderer()
        }
    }
}
