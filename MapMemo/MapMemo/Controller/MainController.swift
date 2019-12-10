//
//  MainController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

class MainController: UIViewController {
    
    let addReminderController = AddReminderController()
    let editReminderController = EditReminderController()
    let activeReminderController = ActiveRemindersController()
    
//    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let notificationManager = LocationNotificationManager.shared//.notificationCenter

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.appBackgroundColor
        
        setupView()
        setupNavigationBar()
    }
    
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
    
    private func setupView() {
        view.addSubview(addButton)
                
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            addButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let activeRemindersBarButton = UIBarButtonItem(customView: activeRemindersButton)
        self.navigationItem.leftBarButtonItem = activeRemindersBarButton
    }
    
    @objc func presentReminderController(sender: Any?) {
        print("Launching ReminderController")
        navigationController?.pushViewController(addReminderController, animated: true)
    }

    @objc private func presentActiveRemindersController(sender: UIBarButtonItem) {
        print("Presenting ActiveRemindersController")
        navigationController?.pushViewController(activeReminderController, animated: true)
    }
}

