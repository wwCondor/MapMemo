//
//  ActiveRemindersController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit
// tableView that holds all current active reminders
// tapping a reminder name presents editReminderController

class ActiveRemindersController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorSet.appBackgroundColor
        
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        
    }
    
    private func setupNavigationBar() {
        let backBarButtonItem = UIImage(named: Icon.backIcon.name)!.withRenderingMode(.alwaysTemplate)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backBarButtonItem
        self.navigationController?.navigationBar.backIndicatorImage = backBarButtonItem
    }
}


