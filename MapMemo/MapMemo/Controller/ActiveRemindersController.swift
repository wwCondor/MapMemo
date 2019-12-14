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

class ReminderCell: UITableViewCell {

}

class ActiveRemindersController: UIViewController {
    
    let reminderController = ReminderController()
    
    var reminders: [MapMemoStub] = [] // MARK: Test
    
    let cellId = "cellId"
    
    lazy var activeReminders: UITableView = {
        let activeReminders = UITableView(frame: view.frame)
        activeReminders.backgroundColor = UIColor.yellow
        activeReminders.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        activeReminders.dataSource = self
        activeReminders.delegate = self
        activeReminders.translatesAutoresizingMaskIntoConstraints = false
        return activeReminders
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.appBackgroundColor
        
        setupView()
        setupNavigationBar()
        addReminders()
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
    
    func addReminders() {
        reminders.append(MapMemoStub.init(title: "First Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 10, triggerWhenEntering: true, locationId: "LocationId1", isRepeating: false, bubbleColor: BubbleColor.black.string))
        reminders.append(MapMemoStub.init(title: "Second Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 20, triggerWhenEntering: false, locationId: "LocationId2", isRepeating: true, bubbleColor: BubbleColor.blue.string))
        reminders.append(MapMemoStub.init(title: "Third Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 30, triggerWhenEntering: true, locationId: "LocationId3", isRepeating: false, bubbleColor: BubbleColor.green.string))
        reminders.append(MapMemoStub.init(title: "Fourth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 40, triggerWhenEntering: false, locationId: "LocationId4", isRepeating: true, bubbleColor: BubbleColor.red.string))
        reminders.append(MapMemoStub.init(title: "Fifth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 50, triggerWhenEntering: true, locationId: "LocationId5", isRepeating: false, bubbleColor: BubbleColor.yellow.string))
        reminders.append(MapMemoStub.init(title: "Sixth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 60, triggerWhenEntering: false, locationId: "LocationId6", isRepeating: true, bubbleColor: BubbleColor.black.string))
        reminders.append(MapMemoStub.init(title: "Seventh Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 70, triggerWhenEntering: true, locationId: "LocationId7", isRepeating: false, bubbleColor: BubbleColor.blue.string))
        reminders.append(MapMemoStub.init(title: "Eigth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 80, triggerWhenEntering: false, locationId: "LocationId8", isRepeating: true, bubbleColor: BubbleColor.green.string))
        reminders.append(MapMemoStub.init(title: "Ninth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 90, triggerWhenEntering: true, locationId: "LocationId9", isRepeating: false, bubbleColor: BubbleColor.red.string))
        reminders.append(MapMemoStub.init(title: "Tenth Reminder", message: "Some Body", coordinate: Coordinate(longitude: 123.0, lattitude: 456.0), bubbleRadius: 100, triggerWhenEntering: false, locationId: "LocationId0", isRepeating: true, bubbleColor: BubbleColor.yellow.string))
        activeReminders.reloadData()
    }
}


extension ActiveRemindersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reminderController.modeSelected = .editReminderMode
        navigationController?.pushViewController(reminderController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reminders.count == 0 {
            return 1
        } else {
            return reminders.count
        }    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.backgroundColor = UIColor.red
        cell.selectionStyle = .none
        
        if reminders.count == 0 {
            cell.textLabel!.text = "loading data..."
        } else {
            let reminder = reminders[indexPath.row]
            cell.textLabel!.text = reminder.title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            reminders.remove(at: indexPath.row)
            activeReminders.reloadData()
        }
    }
}

    

