//
//  EditReminderController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// User adds or edits reminder by editing required information:
class ReminderController: UIViewController, UIScrollViewDelegate {
    
    var modeSelected: ModeSelected = .addReminderMode
    
    var bubbleColors: [String] = [Color.bubbleRed.name, Color.bubbleYellow.name, Color.bubbleBlue.name]
    var radiusInMeters: Int = 10
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = UIColor.systemYellow
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
//    lazy var objectSeparator: UIView = {
//        let objectSeparator = UIView()
//        return objectSeparator
//    }()
    
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
        titleInputField.text = "Enter Reminder Title"
        return titleInputField
    }()
    
    lazy var addressInputField: TextInputField = {
        let addressInputField = TextInputField()
        addressInputField.text = "Enter Address"
        return addressInputField
    }()
    
    lazy var longitudeInputField: TextInputField = {
        let longitudeInfoField = TextInputField()
        longitudeInfoField.text = "Longitude"
        return longitudeInfoField
    }()
    
    lazy var latitudeInputField: TextInputField = {
        let latitudeInfoField = TextInputField()
        latitudeInfoField.text = "Latitude"
        return latitudeInfoField
    }()
    
    lazy var messageInputField: TextInputField = {
        let messageInputField = TextInputField()
        messageInputField.text = "A short message for your reminder."
        return messageInputField
    }()
    
    lazy var triggerInfoField: TextInputField = {
        let triggerInfoField = TextInputField()
        triggerInfoField.text = "Trigger reminder when leaving bubble"
        return triggerInfoField
    }()
    
    lazy var repeatOrNotInfoField: TextInputField = {
        let repeatOrNotInfoField = TextInputField()
        repeatOrNotInfoField.text = "Use Reminder Once"
        return repeatOrNotInfoField
    }()
    
    lazy var bubbleColorInfoField: TextInputField = {
        let bubbleColorInfoField = TextInputField()
        bubbleColorInfoField.text = "Bubble color"
        return bubbleColorInfoField
    }()
    
    lazy var bubbleRadiusInfoField: TextInputField = {
        let bubbleRadiusInfoField = TextInputField()
        bubbleRadiusInfoField.text = "Bubble radius: \(radiusInMeters)m"
        return bubbleRadiusInfoField
    }()
    
    lazy var bubbleColorView: UIView = {
        let bubbleColorView = UIView()
        bubbleColorView.translatesAutoresizingMaskIntoConstraints = false
        bubbleColorView.layer.masksToBounds = true
        bubbleColorView.backgroundColor = UIColor(named: self.bubbleColors[0])!.withAlphaComponent(0.7)
        bubbleColorView.layer.borderWidth = 3
        bubbleColorView.layer.borderColor = UIColor(named: self.bubbleColors[0])?.cgColor
        bubbleColorView.layer.cornerRadius = Constant.inputFieldSize/4 // Set later?
        return bubbleColorView
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        scrollView.addSubview(contentView)
        scrollView.addSubview(titleInputField)
        scrollView.addSubview(addressInputField)
        scrollView.addSubview(longitudeInputField)
        scrollView.addSubview(latitudeInputField)
        scrollView.addSubview(messageInputField)
        scrollView.addSubview(triggerInfoField)
        scrollView.addSubview(repeatOrNotInfoField)
        scrollView.addSubview(bubbleColorInfoField)
        scrollView.addSubview(bubbleColorView)
        scrollView.addSubview(bubbleRadiusInfoField)
        
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
            
            addressInputField.topAnchor.constraint(equalTo: titleInputField.bottomAnchor),
            addressInputField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            addressInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            longitudeInputField.topAnchor.constraint(equalTo: addressInputField.bottomAnchor),
            longitudeInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            longitudeInputField.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            longitudeInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),

            latitudeInputField.topAnchor.constraint(equalTo: addressInputField.bottomAnchor),
            latitudeInputField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            latitudeInputField.widthAnchor.constraint(equalToConstant: view.bounds.width/2),
            latitudeInputField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            messageInputField.topAnchor.constraint(equalTo: longitudeInputField.bottomAnchor),
            messageInputField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            messageInputField.heightAnchor.constraint(equalToConstant: 2*Constant.inputFieldSize),
            
            triggerInfoField.topAnchor.constraint(equalTo: messageInputField.bottomAnchor),
            triggerInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            triggerInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            repeatOrNotInfoField.topAnchor.constraint(equalTo: triggerInfoField.bottomAnchor),
            repeatOrNotInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            repeatOrNotInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            bubbleColorInfoField.topAnchor.constraint(equalTo: repeatOrNotInfoField.bottomAnchor),
            bubbleColorInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bubbleColorInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize),
            
            bubbleColorView.topAnchor.constraint(equalTo: repeatOrNotInfoField.bottomAnchor, constant: Constant.offset),
            bubbleColorView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.offset),
            bubbleColorView.widthAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            bubbleColorView.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize/2),
            
            bubbleRadiusInfoField.topAnchor.constraint(equalTo: bubbleColorInfoField.bottomAnchor),
            bubbleRadiusInfoField.widthAnchor.constraint(equalToConstant: view.bounds.width),
            bubbleRadiusInfoField.heightAnchor.constraint(equalToConstant: Constant.inputFieldSize)
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


