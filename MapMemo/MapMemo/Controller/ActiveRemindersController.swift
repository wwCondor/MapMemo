//
//  ActiveRemindersController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreData
// tableView that holds all current active reminders
// tapping a reminder name presents editReminderController
class ActiveRemindersController: UIViewController {
    
    let reminderController = ReminderController()
    
    var managedObjectContext: NSManagedObjectContext! // MARK: Added - Test
    
    lazy var fetchedResultsController: FetchedResultsController = { // MARK: Added - Test
        return FetchedResultsController(managedObjectContext: self.managedObjectContext, tableView: self.activeReminders, request: Reminder.fetchRequest())
    }()
    
//    var reminders: [MapMemoStub] = [] // MARK: Test
    
    let cellId = "cellId"
    
    lazy var activeReminders: UITableView = {
        let activeReminders = UITableView(frame: view.frame)
        activeReminders.backgroundColor = UIColor.clear
        activeReminders.register(ReminderCell.self, forCellReuseIdentifier: cellId)
        activeReminders.dataSource = self
        activeReminders.delegate = self
        activeReminders.translatesAutoresizingMaskIntoConstraints = false
        return activeReminders
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = fetchedResultsController

        view.backgroundColor = UIColor(named: .appBackgroundColor)
        
        setupView()
        setupNavigationBar()
//        addReminders()
    }
    
    private func setupView() {
        view.addSubview(activeReminders)
        
        NSLayoutConstraint.activate([
            activeReminders.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            activeReminders.widthAnchor.constraint(equalToConstant: view.bounds.width),
            activeReminders.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let backBarButtonItem = UIImage(named: Icon.backIcon.name)!.withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBarButtonItem
        self.navigationController?.navigationBar.backIndicatorImage = backBarButtonItem
    }
    
//    func addReminders() {
//        reminders.append(MapMemoStub.init(title: "First Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 10, triggerWhenEntering: true, locationId: "LocationId1", isRepeating: false, bubbleColor: BubbleColor.black.string))
//        reminders.append(MapMemoStub.init(title: "Second Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 20, triggerWhenEntering: false, locationId: "LocationId2", isRepeating: true, bubbleColor: BubbleColor.blue.string))
//        reminders.append(MapMemoStub.init(title: "Third Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 30, triggerWhenEntering: true, locationId: "LocationId3", isRepeating: false, bubbleColor: BubbleColor.green.string))
//        reminders.append(MapMemoStub.init(title: "Fourth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 40, triggerWhenEntering: false, locationId: "LocationId4", isRepeating: true, bubbleColor: BubbleColor.red.string))
//        reminders.append(MapMemoStub.init(title: "Fifth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 50, triggerWhenEntering: true, locationId: "LocationId5", isRepeating: false, bubbleColor: BubbleColor.yellow.string))
//        reminders.append(MapMemoStub.init(title: "Sixth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 60, triggerWhenEntering: false, locationId: "LocationId6", isRepeating: true, bubbleColor: BubbleColor.black.string))
//        reminders.append(MapMemoStub.init(title: "Seventh Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 70, triggerWhenEntering: true, locationId: "LocationId7", isRepeating: false, bubbleColor: BubbleColor.blue.string))
//        reminders.append(MapMemoStub.init(title: "Eigth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 80, triggerWhenEntering: false, locationId: "LocationId8", isRepeating: true, bubbleColor: BubbleColor.green.string))
//        reminders.append(MapMemoStub.init(title: "Ninth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 90, triggerWhenEntering: true, locationId: "LocationId9", isRepeating: false, bubbleColor: BubbleColor.red.string))
//        reminders.append(MapMemoStub.init(title: "Tenth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 100, triggerWhenEntering: false, locationId: "LocationId0", isRepeating: true, bubbleColor: BubbleColor.yellow.string))
//        activeReminders.reloadData()
//    }
}

extension ActiveRemindersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let reminder = fetchedResultsController.object(at: indexPath)
        reminderController.modeSelected = .editReminderMode
        reminderController.managedObjectContext = self.managedObjectContext // MARK: Added - Test
        reminderController.reminder = reminder
        reminderController.updateInfoForSelectedReminder()
        navigationController?.pushViewController(reminderController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return section.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reminder = fetchedResultsController.object(at: indexPath)
        let cell = activeReminders.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ReminderCell
        cell.backgroundColor = UIColor(named: .appBackgroundColor)
        cell.layer.borderColor = UIColor(named: .objectColor)?.cgColor
        cell.layer.borderWidth = Constant.borderWidth
        cell.selectionStyle = .none
        
        cell.titleInfoField.text = reminder.title
        cell.messageInfoField.text = reminder.message
        cell.locationInfoField.text = reminder.locationName
        
        if reminder.triggerWhenEntering == true {
            cell.arrowImage.transform = CGAffineTransform.identity
        } else if reminder.triggerWhenEntering == false {
            cell.arrowImage.transform = CGAffineTransform(rotationAngle: .pi)
        }
        
        if reminder.isRepeating == true {
            cell.recurringInfoField.text = ToggleText.isRepeating
        } else if reminder.isRepeating == false {
            cell.recurringInfoField.text = ToggleText.isNotRepeating
        }
        
        cell.bubbleColorView.backgroundColor = UIColor(named: reminder.bubbleColor)!.withAlphaComponent(0.7)
        cell.bubbleColorView.layer.borderColor = UIColor(named: reminder.bubbleColor)?.cgColor
        
        cell.radiusInfoField.text = "\(Int(reminder.bubbleRadius))m"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constant.activeReminderCellSize// + Constant.cellSpacing
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: Delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let reminder = fetchedResultsController.object(at: indexPath)
            reminder.managedObjectContext?.delete(reminder)
            reminder.managedObjectContext?.saveChanges()
        }
        activeReminders.reloadData()

//        if (editingStyle == .delete) {
//            reminders.remove(at: indexPath.row)
//            activeReminders.reloadData()
//        }
    }
}

    

