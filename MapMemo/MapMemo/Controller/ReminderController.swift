//
//  EditReminderController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import MapKit
import CoreData

// User adds or edits reminder by editing required information:
class ReminderController: UIViewController {
    
    let cellId = "searchResultsId"
    
    var modeSelected: ModeSelected = .addReminderMode
    var managedObjectContext: NSManagedObjectContext!
    var reminder: Reminder?
    
    let searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    var colorSelected = 0
    var bubbleColors: [String] = [Color.bubbleRed.name, Color.bubbleYellow.name, Color.bubbleBlue.name]
    
    var radiusInMeters: Double = 50
    
    lazy var backButton: CustomButton = {
        let backButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.backIcon.name)?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(image, for: .normal)
        let inset: CGFloat = 2
        backButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 8, right: inset + 30)
        backButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return backButton
    }()
    
    lazy var deleteButton: CustomButton = {
        let deleteButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.deleteIcon.name)?.withRenderingMode(.alwaysTemplate)
        deleteButton.setImage(image, for: .normal)
        let inset: CGFloat = 4
        deleteButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset + 10, right: inset + 40)
        deleteButton.addTarget(self, action: #selector(deleteReminder), for: .touchUpInside)
        return deleteButton
    }()
    
    lazy var saveButton: CustomButton = {
        let saveButton = CustomButton(type: .custom)
        let image = UIImage(named: Icon.saveIcon.name)?.withRenderingMode(.alwaysTemplate)
        saveButton.setImage(image, for: .normal)
        let inset: CGFloat = 10
        saveButton.imageEdgeInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        saveButton.addTarget(self, action: #selector(saveReminder(sender:)), for: .touchUpInside)
        return saveButton
    }()
    
    lazy var titleInputField: CustomTextField = {
        let titleInputField = CustomTextField()
        titleInputField.text = PlaceHolderText.title
        return titleInputField
    }()
    
    lazy var messageInputField: CustomTextField = {
        let messageInputField = CustomTextField()
        messageInputField.text = PlaceHolderText.message
        return messageInputField
    }()
    
    lazy var locationSearchBar: UISearchBar = {
        let locationSearchBar = UISearchBar()
        return locationSearchBar
    }()
    
    lazy var searchResultsTableView: UITableView = {
        let searchResultsTableView = UITableView()
        searchResultsTableView.backgroundColor = UIColor.clear
        searchResultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        return searchResultsTableView
    }()
    
    lazy var latitudeInputField: CustomTextField = {
        let latitudeInfoField = CustomTextField()
        latitudeInfoField.text = PlaceHolderText.latitude
        latitudeInfoField.isUserInteractionEnabled = false
        return latitudeInfoField
    }()
    
    lazy var longitudeInputField: CustomTextField = {
        let longitudeInfoField = CustomTextField()
        longitudeInfoField.text = PlaceHolderText.longitude
        longitudeInfoField.isUserInteractionEnabled = false
        return longitudeInfoField
    }()
    
    lazy var triggerInfoField: CustomTextField = {
        let triggerInfoField = CustomTextField()
        triggerInfoField.text = ToggleText.leavingTrigger
        triggerInfoField.isUserInteractionEnabled = false
        return triggerInfoField
    }()
    
    lazy var triggerToggle: TapToggleView = {
        let triggerToggle = TapToggleView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleTriggerMode(sender:)))
        triggerToggle.addGestureRecognizer(tapGesture)
        return triggerToggle
    }()
    
    lazy var repeatOrNotInfoField: CustomTextField = {
        let repeatOrNotInfoField = CustomTextField()
        repeatOrNotInfoField.text = ToggleText.isNotRepeating
        repeatOrNotInfoField.isUserInteractionEnabled = false
        return repeatOrNotInfoField
    }()
    
    lazy var repeatToggle: TapToggleView = {
        let repeatToggle = TapToggleView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleRepeatMode(sender:)))
        repeatToggle.addGestureRecognizer(tapGesture)
        return repeatToggle
    }()
    
    lazy var bubbleColorInfoField: CustomTextField = {
        let bubbleColorInfoField = CustomTextField()
        bubbleColorInfoField.text = PlaceHolderText.bubbleColor
        bubbleColorInfoField.isUserInteractionEnabled = false
        return bubbleColorInfoField
    }()
    
    lazy var colorToggle: UIView = {
        let colorToggle = UIView()
        colorToggle.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleColor(sender:)))
        colorToggle.addGestureRecognizer(tapGesture)
        return colorToggle
    }()
 
    lazy var bubbleColorView: UIView = {
        let bubbleColorView = UIView()
        bubbleColorView.translatesAutoresizingMaskIntoConstraints = false
        bubbleColorView.layer.masksToBounds = true
        bubbleColorView.backgroundColor = UIColor(named: self.bubbleColors[colorSelected])!.withAlphaComponent(0.7)
        bubbleColorView.layer.borderWidth = 3
        bubbleColorView.layer.borderColor = UIColor(named: self.bubbleColors[colorSelected])?.cgColor
        bubbleColorView.layer.cornerRadius = Constant.inputFieldSize/4
        return bubbleColorView
    }()
    
    lazy var bubbleRadiusInfoField: CustomTextField = {
        let bubbleRadiusInfoField = CustomTextField()
        bubbleRadiusInfoField.isUserInteractionEnabled = false
        bubbleRadiusInfoField.text = "Bubble radius: \(radiusInMeters.clean)m"
        return bubbleRadiusInfoField
    }()
    
    lazy var sliderBackground: UIView = {
        let sliderBackground = UIView()
        sliderBackground.translatesAutoresizingMaskIntoConstraints = false
        sliderBackground.layer.borderWidth = Constant.borderWidth
        sliderBackground.layer.borderColor = UIColor(named: .objectBorderColor)?.cgColor
        return sliderBackground
    }()
    
    lazy var bubbleRadiusSlider: UISlider = {
        let bubbleRadiusSlider = UISlider()
        bubbleRadiusSlider.translatesAutoresizingMaskIntoConstraints = false
        bubbleRadiusSlider.backgroundColor = UIColor.clear
        bubbleRadiusSlider.minimumTrackTintColor = UIColor(named: .objectColor)
        bubbleRadiusSlider.maximumTrackTintColor = UIColor(named: .tintColor)
        bubbleRadiusSlider.thumbTintColor = UIColor(named: .tintColor)
        bubbleRadiusSlider.minimumValue = 0
        bubbleRadiusSlider.maximumValue = 6
        bubbleRadiusSlider.setValue(2, animated: true)
        bubbleRadiusSlider.addTarget(self, action: #selector(setBubbleRadius(_:)), for: .valueChanged)
        return bubbleRadiusSlider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: .appBackgroundColor)
        
        self.hideKeyboardOnBackgroundTap()
        
        titleInputField.delegate = self
        messageInputField.delegate = self
        locationSearchBar.delegate = self
        searchCompleter.delegate = self
        
        if modeSelected == .addReminderMode {
            setupNavigationBarForAddMode()
        } else if modeSelected == .editReminderMode {
            setupNavigationBarForEditMode()
        }
        setupView()
        setupSearchBar()
    }
    
    
    private func setupSearchBar() {
        locationSearchBar.translatesAutoresizingMaskIntoConstraints = false
        locationSearchBar.delegate = self
        locationSearchBar.placeholder = PlaceHolderText.location
        locationSearchBar.barTintColor = UIColor(named: .appBackgroundColor)
        locationSearchBar.tintColor = UIColor(named: .tintColor)
        locationSearchBar.searchTextField.textColor = UIColor(named: .tintColor)
        locationSearchBar.searchTextField.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        locationSearchBar.keyboardAppearance = .dark
        locationSearchBar.returnKeyType = .done
    }
    
    func updateInfoForSelectedReminder() {
        if let reminder = reminder {
            titleInputField.text = reminder.title
            messageInputField.text = reminder.message
            latitudeInputField.text = String(describing: reminder.latitude)
            longitudeInputField.text = String(describing: reminder.longitude)
            locationSearchBar.text = reminder.locationName
            
            if reminder.triggerWhenEntering == true {
                triggerInfoField.text = ToggleText.enteringTrigger
            } else if reminder.triggerWhenEntering == false {
                triggerInfoField.text = ToggleText.leavingTrigger
            }
            
            if reminder.isRepeating == true {
                repeatOrNotInfoField.text = ToggleText.isRepeating
            } else if reminder.isRepeating == false {
                repeatOrNotInfoField.text = ToggleText.isNotRepeating
            }
            
            bubbleColorView.backgroundColor = UIColor(named: reminder.bubbleColor)!.withAlphaComponent(0.7)
            bubbleColorView.layer.borderColor = UIColor(named: reminder.bubbleColor)?.cgColor
            bubbleRadiusInfoField.text = "\(reminder.bubbleRadius.clean)m"
        } else {
            presentAlert(description: ReminderError.reminderNil.localizedDescription, viewController: self)
        }
    }
    
    private func setupView() {
        view.addSubview(saveButton)
        view.addSubview(titleInputField)
        view.addSubview(messageInputField)
        view.addSubview(longitudeInputField)
        view.addSubview(searchResultsTableView)
        view.addSubview(latitudeInputField)
        view.addSubview(locationSearchBar)
        view.addSubview(triggerInfoField)
        view.addSubview(triggerToggle)
        view.addSubview(repeatOrNotInfoField)
        view.addSubview(repeatToggle)
        view.addSubview(bubbleColorInfoField)
        view.addSubview(bubbleColorView)
        view.addSubview(colorToggle)
        view.addSubview(bubbleRadiusInfoField)
        view.addSubview(sliderBackground)
        view.addSubview(bubbleRadiusSlider)
        
        if modeSelected == .addReminderMode {
            NSLayoutConstraint.activate([
                saveButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
                saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
                saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else if modeSelected == .editReminderMode {
            updateInfoForSelectedReminder() 
            NSLayoutConstraint.activate([
                backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
                deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
                
                saveButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
                saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
                saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            titleInputField.topAnchor.constraint(equalTo: view.topAnchor),
            titleInputField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            titleInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            messageInputField.topAnchor.constraint(equalTo: titleInputField.bottomAnchor),
            messageInputField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            messageInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            locationSearchBar.topAnchor.constraint(equalTo: messageInputField.bottomAnchor),
            locationSearchBar.widthAnchor.constraint(equalToConstant: view.bounds.width),
            locationSearchBar.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            searchResultsTableView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor),
            searchResultsTableView.bottomAnchor.constraint(equalTo: latitudeInputField.topAnchor),
            searchResultsTableView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            searchResultsTableView.heightAnchor.constraint(equalToConstant: Constant.searchResultsTableSize),

            latitudeInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            latitudeInputField.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            latitudeInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            latitudeInputField.bottomAnchor.constraint(equalTo: triggerInfoField.topAnchor),

            longitudeInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            longitudeInputField.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            longitudeInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            longitudeInputField.bottomAnchor.constraint(equalTo: triggerInfoField.topAnchor),

            triggerInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            triggerInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            triggerInfoField.bottomAnchor.constraint(equalTo: repeatOrNotInfoField.topAnchor),
            
            triggerToggle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            triggerToggle.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            triggerToggle.bottomAnchor.constraint(equalTo: repeatOrNotInfoField.topAnchor),

            repeatOrNotInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            repeatOrNotInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            repeatOrNotInfoField.bottomAnchor.constraint(equalTo: bubbleColorInfoField.topAnchor),
            
            repeatToggle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            repeatToggle.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            repeatToggle.bottomAnchor.constraint(equalTo: bubbleColorInfoField.topAnchor),

            bubbleColorInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bubbleColorInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            bubbleColorInfoField.bottomAnchor.constraint(equalTo: bubbleRadiusInfoField.topAnchor),
            
            colorToggle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            colorToggle.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            colorToggle.bottomAnchor.constraint(equalTo: bubbleRadiusInfoField.topAnchor),

            bubbleColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            bubbleColorView.widthAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            bubbleColorView.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            bubbleColorView.bottomAnchor.constraint(equalTo: bubbleRadiusInfoField.topAnchor, constant: -Constant.offset),

            bubbleRadiusInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bubbleRadiusInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            bubbleRadiusInfoField.bottomAnchor.constraint(equalTo: bubbleRadiusSlider.topAnchor),

            bubbleRadiusSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.offset),
            bubbleRadiusSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            bubbleRadiusSlider.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            bubbleRadiusSlider.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            
            sliderBackground.widthAnchor.constraint(equalTo: view.widthAnchor),
            sliderBackground.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            sliderBackground.bottomAnchor.constraint(equalTo: saveButton.topAnchor)
        ])
    }
    
    private func setupNavigationBarForEditMode() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        let deleteBarButtonItem = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.rightBarButtonItem = deleteBarButtonItem
    }
    
    private func setupNavigationBarForAddMode() {
        let backBarButtonItem = UIImage(named: Icon.backIcon.name)!.withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBarButtonItem
        self.navigationController?.navigationBar.backIndicatorImage = backBarButtonItem
    }
    
    // MARK: Toggles
    @objc func toggleTriggerMode(sender: UITapGestureRecognizer) {
        view.endEditing(true)
        triggerToggle.viewTapped()
        if triggerToggle.isOn == true {
            triggerInfoField.text = ToggleText.enteringTrigger
        } else if triggerToggle.isOn == false {
            triggerInfoField.text = ToggleText.leavingTrigger
        }
    }
    
    @objc func toggleRepeatMode(sender: UITapGestureRecognizer) {
        view.endEditing(true)
        repeatToggle.viewTapped()
        if repeatToggle.isOn == true {
            repeatOrNotInfoField.text = ToggleText.isRepeating
        } else if repeatToggle.isOn == false {
            repeatOrNotInfoField.text = ToggleText.isNotRepeating
        }
    }
    
    @objc func toggleColor(sender: UITapGestureRecognizer) {
        view.endEditing(true)
        if colorSelected != bubbleColors.count - 1 {
            colorSelected += 1
        } else if colorSelected == bubbleColors.count - 1 {
            colorSelected = 0
        }
        bubbleColorView.backgroundColor = UIColor(named: self.bubbleColors[colorSelected])!.withAlphaComponent(0.7)
        bubbleColorView.layer.borderColor = UIColor(named: self.bubbleColors[colorSelected])?.cgColor
    }
    
    @objc func setBubbleRadius(_ sender: UISlider) { // thumb size = 30x30
        view.endEditing(true)
        sender.value = roundf(sender.value) // this allows thumb to snap between values
        let radiiInMeters: [Double] = [10, 25, 50, 100, 500, 1000, 5000]
        let radiusSelected = Double(radiiInMeters[Int(roundf(sender.value))])
        radiusInMeters = radiusSelected
        bubbleRadiusInfoField.text = "Bubble radius: \(radiusSelected.clean)m"
    }

    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Delete
    @objc private func deleteReminder(sender: UIButton!) {
        print("Reminder Deleted")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Save
    @objc private func saveReminder(sender: UIButton!) {
        if modeSelected == .addReminderMode {
            guard let title = titleInputField.text, !title.isEmpty, title != PlaceHolderText.title else {
                presentAlert(description: ReminderError.missingTitle.localizedDescription, viewController: self)
                return
            }
            guard let message = messageInputField.text, !message.isEmpty, message != PlaceHolderText.message else {
                presentAlert(description: ReminderError.missingMessage.localizedDescription, viewController: self)
                return
            }
            guard let latitude = latitudeInputField.text, !latitude.isEmpty, latitude != PlaceHolderText.message else {
                presentAlert(description: ReminderError.missingLatitude.localizedDescription, viewController: self)
                return
            }
            guard let longitude = longitudeInputField.text, !longitude.isEmpty, longitude != PlaceHolderText.message else {
                presentAlert(description: ReminderError.missingLongitude.localizedDescription, viewController: self)
                return
            }
            guard let locationName = locationSearchBar.text, !locationName.isEmpty else {
                presentAlert(description: ReminderError.missingLocationName.localizedDescription, viewController: self)
                return
            }
            
            let reminder = NSEntityDescription.insertNewObject(forEntityName: "Reminder", into: managedObjectContext) as! Reminder
            
            reminder.title = title
            reminder.message = message
            reminder.latitude = latitude.doubleValue
            reminder.longitude = longitude.doubleValue
            reminder.locationName = locationName
            reminder.triggerWhenEntering = triggerToggle.isOn
            reminder.isRepeating = repeatToggle.isOn
            reminder.bubbleColor = bubbleColors[colorSelected]
            reminder.bubbleRadius = Double(radiusInMeters)
            
            reminder.managedObjectContext?.saveChanges()
            
            print("Reminder Saved: \(reminder.title)")
        } else if modeSelected == .editReminderMode {
            if let reminder = reminder, let newTitle = titleInputField.text, let newMessage = messageInputField.text, let newLatitude = latitudeInputField.text, let newLongitude = longitudeInputField.text, let newLocationName = locationSearchBar.text {
                reminder.title = newTitle
                reminder.message = newMessage
                reminder.latitude = newLatitude.doubleValue
                reminder.longitude = newLongitude.doubleValue
                reminder.locationName = newLocationName
                
                reminder.triggerWhenEntering = triggerToggle.isOn
                reminder.isRepeating = repeatToggle.isOn
                reminder.bubbleColor = bubbleColors[colorSelected]
                reminder.bubbleRadius = Double(radiusInMeters)
                
                reminder.managedObjectContext?.saveChanges()
                print("Changes Saved for Reminder: \(reminder.title)")
            } else {
                if reminder == nil {
                    presentAlert(description: ReminderError.reminderNil.localizedDescription, viewController: self)
                } else if reminder?.title == "" {
                    presentAlert(description: ReminderError.missingTitle.localizedDescription, viewController: self)
                } else if reminder?.message == "" {
                    presentAlert(description: ReminderError.missingMessage.localizedDescription, viewController: self)
                } else if reminder?.latitude.toString == "" {
                    presentAlert(description: ReminderError.missingLatitude.localizedDescription, viewController: self)
                } else if reminder?.longitude.toString == "" {
                    presentAlert(description: ReminderError.missingLongitude.localizedDescription, viewController: self)
                } else if reminder?.locationName == "" {
                    presentAlert(description: ReminderError.missingLocationName.localizedDescription, viewController: self)
                }
            }
        }
        navigationController?.popViewController(animated: true)
        // MARK: Send out notification?
        // We need to notify the MainController that a new reminder is added or edited
    }
}

extension ReminderController: UITextFieldDelegate {
    // Makes sure input is not longer than given max
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxCharactersIntitle = 20
        let maxCharactersInMessage = 40

        switch textField {
        case titleInputField:
            let currentString = titleInputField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxCharactersIntitle
        case messageInputField:
            let currentString = messageInputField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxCharactersInMessage
        default:
            return true // Allows backspace
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder() // show Keyboard when user taps textField
        // If current text is placeholder text, reset it to ""
        guard let text = textField.text else { return }

        switch textField {
        case titleInputField:
            if text == PlaceHolderText.title {
                textField.text = ""
            }
        case messageInputField:
            if text == PlaceHolderText.message {
                textField.text = ""
            }
        case locationSearchBar:
            if text == PlaceHolderText.location {
                textField.text = ""
            }
        default: break
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // If input field is empty, placeholder text is restored
        textField.resignFirstResponder()
            guard let input = textField.text else { return }
        
            switch textField {
            case titleInputField:
                if input.isEmpty {
                    titleInputField.text = PlaceHolderText.title
                }
            case messageInputField:
                if input.isEmpty {
                    messageInputField.text = PlaceHolderText.message
                }
            case locationSearchBar:
                if input.isEmpty {
                    locationSearchBar.text = PlaceHolderText.location
                }
            default:
                break
            }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss Keyboard if "return" pressed
        textField.resignFirstResponder()
        return true
    }
}

extension ReminderController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
}

extension ReminderController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // MARK: Handle Errors
    }
}

extension ReminderController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        cell.textLabel?.textColor = UIColor(named: .tintColor)
        cell.detailTextLabel?.textColor = UIColor(named: .tintColor)
        cell.backgroundColor = UIColor(named: .appBackgroundColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (result, error) in
            let coordinate = result?.mapItems.last?.placemark.coordinate
            self.latitudeInputField.text = coordinate?.latitude.toString
            self.longitudeInputField.text = coordinate?.longitude.toString
            self.locationSearchBar.text = "\(completion.title) in \(completion.subtitle)"
        }
    }
}
