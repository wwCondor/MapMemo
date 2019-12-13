//
//  EditReminderController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
import CoreLocation

// User adds or edits reminder by editing required information:
class ReminderController: UIViewController {//}, UIScrollViewDelegate {
    
    var modeSelected: ModeSelected = .addReminderMode
    
    var colorSelected = 0
    var bubbleColors: [String] = [Color.bubbleRed.name, Color.bubbleYellow.name, Color.bubbleBlue.name]
    
    var latitudeReceived: Bool = false
    var longitudeReceived: Bool = false
    
    var radiusInMeters: Int = 50
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = ColorSet.appBackgroundColor
        scrollView.layer.borderColor = ColorSet.objectColor.cgColor
        scrollView.layer.borderWidth = Constant.borderWidth
        scrollView.contentSize.height = Constant.inputFieldSize*10
//        scrollView.isUserInteractionEnabled = true
//        scrollView.isScrollEnabled = true
        scrollView.bounces = true
//        scrollView.delegate = self
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
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
    
    lazy var titleInputField: TextInputField = {
        let titleInputField = TextInputField()
        titleInputField.text = PlaceHolderText.title
        titleInputField.layer.borderWidth = 0
        return titleInputField
    }() // MARK: reminder.title = titleInputField.text
    
    lazy var messageInputField: TextInputField = {
        let messageInputField = TextInputField()
        messageInputField.text = PlaceHolderText.message
        return messageInputField
    }() // MARK: reminder.message = messageInputField.text
    
    lazy var latitudeInputField: TextInputField = {
        let latitudeInfoField = TextInputField()
        latitudeInfoField.text = PlaceHolderText.latitude
        return latitudeInfoField
    }() // MARK: reminder.latitude = latitudeInputField.text save as Float!
    
    lazy var longitudeInputField: TextInputField = {
        let longitudeInfoField = TextInputField()
        longitudeInfoField.text = PlaceHolderText.longitude
        return longitudeInfoField
    }() // MARK: reminder.longitude = longitudeInputField.text save as Float!
    
    lazy var locationInfoField: TextInputField = {
        let locationInfoField = TextInputField()
        locationInfoField.isUserInteractionEnabled = false
        locationInfoField.text = PlaceHolderText.location
        return locationInfoField
    }()
    
    lazy var triggerInfoField: TextInputField = {
        let triggerInfoField = TextInputField()
        triggerInfoField.text = ToggleText.leavingTrigger
        return triggerInfoField
    }()
    
    lazy var triggerToggle: TapToggleView = {
        let triggerToggle = TapToggleView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleTriggerMode(sender:)))
        triggerToggle.addGestureRecognizer(tapGesture)
        return triggerToggle // MARK: reminder.triggerWhenEntering = triggerToggle.isOn

    }()
    
    lazy var repeatOrNotInfoField: TextInputField = {
        let repeatOrNotInfoField = TextInputField()
        repeatOrNotInfoField.text = ToggleText.isNotRepeating
        return repeatOrNotInfoField
    }()
    
    lazy var repeatToggle: TapToggleView = {
        let repeatToggle = TapToggleView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleRepeatMode(sender:)))
        repeatToggle.addGestureRecognizer(tapGesture)
        return repeatToggle // MARK: reminder.isRepeating = repeatToggle.isOn
    }()
    
    lazy var bubbleColorInfoField: TextInputField = {
        let bubbleColorInfoField = TextInputField()
        bubbleColorInfoField.text = PlaceHolderText.bubbleColor
        return bubbleColorInfoField
    }()
    
    lazy var colorToggle: UIView = {
        let colorToggle = UIView()
        colorToggle.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleColor(sender:)))
        colorToggle.addGestureRecognizer(tapGesture)
        return colorToggle // MARK: reminder.bubbleColor = triggerInfoTouchView.isOn
    }()
 
    lazy var bubbleColorView: UIView = {
        let bubbleColorView = UIView()
        bubbleColorView.translatesAutoresizingMaskIntoConstraints = false
        bubbleColorView.layer.masksToBounds = true
        bubbleColorView.backgroundColor = UIColor(named: self.bubbleColors[colorSelected])!.withAlphaComponent(0.7)
        bubbleColorView.layer.borderWidth = 3
        bubbleColorView.layer.borderColor = UIColor(named: self.bubbleColors[colorSelected])?.cgColor
        bubbleColorView.layer.cornerRadius = Constant.inputFieldSize/4 // Set later?
        return bubbleColorView
    }()
    
    lazy var bubbleRadiusInfoField: TextInputField = {
        let bubbleRadiusInfoField = TextInputField()
        bubbleRadiusInfoField.isUserInteractionEnabled = false
        bubbleRadiusInfoField.text = "Bubble radius: \(radiusInMeters)m"
        return bubbleRadiusInfoField
    }()
    
    lazy var bubbleRadiusSlider: UISlider = {
        let bubbleRadiusSlider = UISlider()
        bubbleRadiusSlider.translatesAutoresizingMaskIntoConstraints = false
        bubbleRadiusSlider.backgroundColor = ColorSet.appBackgroundColor
        bubbleRadiusSlider.minimumTrackTintColor = ColorSet.objectColor
        bubbleRadiusSlider.maximumTrackTintColor = ColorSet.tintColor
        bubbleRadiusSlider.thumbTintColor = ColorSet.tintColor
        bubbleRadiusSlider.minimumValue = 0
        bubbleRadiusSlider.maximumValue = 6
        bubbleRadiusSlider.setValue(2, animated: true)
        bubbleRadiusSlider.addTarget(self, action: #selector(setBubbleRadius(_:)), for: .valueChanged)
        return bubbleRadiusSlider
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleInputField.delegate = self
        messageInputField.delegate = self
        latitudeInputField.delegate = self
        longitudeInputField.delegate = self
        
        if modeSelected == .addReminderMode {
            view.backgroundColor = ColorSet.appBackgroundColor
            setupNavigationBarForAddMode()
        } else if modeSelected == .editReminderMode {
            view.backgroundColor = UIColor.systemRed
            setupNavigationBarForEditMode()
        }
        setupView()
    }
    
    private func setupView() {
        view.addSubview(saveButton)
        view.addSubview(scrollView)
        scrollView.addSubview(titleInputField)
        scrollView.addSubview(messageInputField)
        scrollView.addSubview(longitudeInputField)
        scrollView.addSubview(latitudeInputField)
        scrollView.addSubview(locationInfoField)
        scrollView.addSubview(triggerInfoField)
        scrollView.addSubview(triggerToggle)
        scrollView.addSubview(repeatOrNotInfoField)
        scrollView.addSubview(repeatToggle)
        scrollView.addSubview(bubbleColorInfoField)
        scrollView.addSubview(bubbleColorView)
        scrollView.addSubview(colorToggle)
        scrollView.addSubview(bubbleRadiusInfoField)
        scrollView.addSubview(bubbleRadiusSlider)
        
        if modeSelected == .addReminderMode {
            NSLayoutConstraint.activate([
                saveButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
                saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
                saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else if modeSelected == .editReminderMode {
            NSLayoutConstraint.activate([
                backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
                deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
                
                saveButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
                saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
                saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: saveButton.topAnchor),
            
            titleInputField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleInputField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            titleInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            messageInputField.topAnchor.constraint(equalTo: titleInputField.bottomAnchor),
            messageInputField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            messageInputField.heightAnchor.constraint(equalToConstant: 2*Constant.inputFieldSize),

            latitudeInputField.topAnchor.constraint(equalTo: messageInputField.bottomAnchor),
            latitudeInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            latitudeInputField.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            latitudeInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),

            longitudeInputField.topAnchor.constraint(equalTo: messageInputField.bottomAnchor),
            longitudeInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            longitudeInputField.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            longitudeInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            locationInfoField.topAnchor.constraint(equalTo: latitudeInputField.bottomAnchor),
            locationInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            locationInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),

            triggerInfoField.topAnchor.constraint(equalTo: locationInfoField.bottomAnchor),
            triggerInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            triggerInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            triggerToggle.topAnchor.constraint(equalTo: locationInfoField.bottomAnchor),
            triggerToggle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            triggerToggle.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),

            repeatOrNotInfoField.topAnchor.constraint(equalTo: triggerInfoField.bottomAnchor),
            repeatOrNotInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            repeatOrNotInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            repeatToggle.topAnchor.constraint(equalTo: triggerInfoField.bottomAnchor),
            repeatToggle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            repeatToggle.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),

            bubbleColorInfoField.topAnchor.constraint(equalTo: repeatOrNotInfoField.bottomAnchor),
            bubbleColorInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bubbleColorInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),

            bubbleColorView.topAnchor.constraint(equalTo: repeatOrNotInfoField.bottomAnchor, constant: Constant.offset),
            bubbleColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            bubbleColorView.widthAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            bubbleColorView.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            
            colorToggle.topAnchor.constraint(equalTo: repeatOrNotInfoField.bottomAnchor),
            colorToggle.widthAnchor.constraint(equalToConstant: view.bounds.width),
            colorToggle.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),

            bubbleRadiusInfoField.topAnchor.constraint(equalTo: bubbleColorInfoField.bottomAnchor),
            bubbleRadiusInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bubbleRadiusInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            bubbleRadiusSlider.topAnchor.constraint(equalTo: bubbleRadiusInfoField.bottomAnchor),
            bubbleRadiusSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.offset),
            bubbleRadiusSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            bubbleRadiusSlider.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
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
//        print("Toggle ze trigger mode")
        triggerToggle.viewTapped()
        if triggerToggle.isOn == true {
            triggerInfoField.text = ToggleText.enteringTrigger
        } else if triggerToggle.isOn == false {
            triggerInfoField.text = ToggleText.leavingTrigger
        }
    }
    
    @objc func toggleRepeatMode(sender: UITapGestureRecognizer) {
//        print("Toggle ze repeat mode")
        repeatToggle.viewTapped()
        if repeatToggle.isOn == true {
            repeatOrNotInfoField.text = ToggleText.isRepeating
        } else if repeatToggle.isOn == false {
            repeatOrNotInfoField.text = ToggleText.isNotRepeating
        }
    }
    
    @objc func toggleColor(sender: UITapGestureRecognizer) {
        if colorSelected != bubbleColors.count - 1 {
            colorSelected += 1
        } else if colorSelected == bubbleColors.count - 1 {
            colorSelected = 0
        }
        bubbleColorView.backgroundColor = UIColor(named: self.bubbleColors[colorSelected])!.withAlphaComponent(0.7)
        bubbleColorView.layer.borderColor = UIColor(named: self.bubbleColors[colorSelected])?.cgColor
    }
    
    @objc func setBubbleRadius(_ sender: UISlider) { // thumb size = 30x30
        sender.value = roundf(sender.value) // this allows thumb to snap between values
        let radiiInMeters: [Float] = [10, 25, 50, 100, 500, 1000, 5000]
        let radiusSelected = Int(radiiInMeters[Int(roundf(sender.value))])
        radiusInMeters = radiusSelected
        bubbleRadiusInfoField.text = "Bubble radius: \(radiusSelected)m"
    }
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func deleteReminder(sender: UIButton!) {
        print("Reminder Deleted")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveReminder(sender: UIButton!) {
        if modeSelected == .addReminderMode {
            print("Reminder Saved")
        } else if modeSelected == .editReminderMode {
            print("Edits to Reminder Saved")
        }
        navigationController?.popViewController(animated: true)
    }
}

extension ReminderController: UITextFieldDelegate {
    // Makes sure title and/or message input is not to long
    // Makes sure latitude/longitude input is limited to certain characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var result = true
        let maxLengthTitle = 20
        let maxLengthMessage = 40
        
        var currentString: NSString = ""
        
        switch textField {
        case titleInputField:
            currentString = titleInputField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            result = newString.length <= maxLengthTitle
        case messageInputField:
            currentString = messageInputField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            result = newString.length <= maxLengthMessage
        case latitudeInputField, longitudeInputField:
            if string.count > 0 {
                let allowedCharacters = NSCharacterSet(charactersIn: "1234567890.-")//.inverted // This would be opposite
                let stringWithOnlyAllowedCharacters = string.rangeOfCharacter(from: allowedCharacters as CharacterSet) != nil
                result = stringWithOnlyAllowedCharacters
            }
        default:
            break
        }
        return result
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        case latitudeInputField:
            if text == PlaceHolderText.latitude {
                textField.text = ""
            }
        case longitudeInputField:
            if text == PlaceHolderText.longitude {
                textField.text = ""
            }
        default: break
        }
    }
    
    func getLocationName(location: CLLocation) {
        locationInfoField.text = "Trying to obtain location from coordinates..."
        let geographicCoder = CLGeocoder()
        
        geographicCoder.reverseGeocodeLocation(location) { (placemark, error) in
            guard error == nil else {
                self.locationInfoField.text = "Could not obtain location from current coordinates"
                return
            }
            guard let placemark = placemark?.first else { // country
                return
            }
            guard let locality = placemark.locality else { // city
                return
            }
            guard let thoroughfare = placemark.thoroughfare else { // street
                return
            }
//            let locationName = "\(locality)"
            print(placemark)
            let locationName = "\(thoroughfare), \(locality)"
            self.locationInfoField.text = locationName
        }
    }
    
    func checkCoordinateInput() {
        if latitudeReceived == true && longitudeReceived == true {
            // If both are true we try to obtain location from coordinates
            guard let latitude = latitudeInputField.text, let longitude = longitudeInputField.text else { return }
            let location: CLLocation = CLLocation(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
            getLocationName(location: location)
        } else {
            if latitudeReceived == false && longitudeReceived == true {
                locationInfoField.text = PlaceHolderText.locationLatitude
            } else if latitudeReceived == true && longitudeReceived == false {
                locationInfoField.text = PlaceHolderText.locationLongitude
            } else if latitudeReceived == false && longitudeReceived == false {
                locationInfoField.text = PlaceHolderText.location
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            guard let input = textField.text else { return }
        
            switch textField {
            case titleInputField:
                if textField.text!.isEmpty {
                    presentAlert(description: ReminderError.missingTitle.localizedDescription, viewController: self)
                }
            case messageInputField:
                if textField.text!.isEmpty {
                    print("Seems there is not message added to the reminder but maybe that's ok")
//                    presentAlert(description: ReminderError.missingMessage.localizedDescription, viewController: self)
                }
            case latitudeInputField:
                latitudeReceived = false
                if textField.text!.isEmpty {
                    presentAlert(description: ReminderError.missingLatitude.localizedDescription, viewController: self)
                    latitudeReceived = false
                } else {
                    let latitudeLimit: Float = 90
                    if input.floatValue < -latitudeLimit {
                        textField.text = "-90"
                    } else if input.floatValue > latitudeLimit {
                        textField.text = "90"
                    }
                    latitudeReceived = true
                }
                checkCoordinateInput()
            case longitudeInputField:
                longitudeReceived = false
                if textField.text!.isEmpty {
                    presentAlert(description: ReminderError.missingLongitude.localizedDescription, viewController: self)
                    longitudeReceived = false
                } else {
                    let longitudeLimit: Float = 180
                    if input.floatValue < -longitudeLimit {
                        textField.text = "-180"
                    } else if input.floatValue > longitudeLimit {
                        textField.text = "180"
                    }
                    longitudeReceived = true
                }
                checkCoordinateInput()
            default:
                break
            }
    }
}
