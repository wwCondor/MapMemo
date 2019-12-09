//
//  EditReminderController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// User edits reminder by editing required information:
// Reminder name, reminder message, reminder location, reminder triggerMode, reminder fence color (dropdown)

class EditReminderController: UIViewController {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.appBackgroundColor
        
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
            deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * (1/2)),
            
            saveButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        let deleteBarButtonItem = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        self.navigationItem.rightBarButtonItem = deleteBarButtonItem
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
        print("Edited Reminder Saved")
        navigationController?.popViewController(animated: true)
    }
}


