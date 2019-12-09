//
//  AddReminderController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// User adds reminder by enterting required information:
// Reminder name, reminder message, reminder location, reminder triggerMode, reminder fence color (dropdown)

class AddReminderController: UIViewController {
    
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
            saveButton.heightAnchor.constraint(equalToConstant: Constant.buttonBarHeight),
            saveButton.widthAnchor.constraint(equalToConstant: view.bounds.width),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let backBarButtonItem = UIImage(named: Icon.backIcon.name)!.withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBarButtonItem
        self.navigationController?.navigationBar.backIndicatorImage = backBarButtonItem
    }
    
    @objc private func saveReminder(sender: UIButton!) {
        print("Reminder Saved")
        navigationController?.popViewController(animated: true)
    }
}
