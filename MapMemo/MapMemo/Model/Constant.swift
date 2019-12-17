//
//  Constant.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

struct Constant {
    static let buttonBarHeight: CGFloat         = 60 // height of buttons/buttonbars
    static let largeTextInset: CGFloat          = 10
    static let smallTextInset: CGFloat          = 2
    static let borderWidth: CGFloat             = 2
    static let inputFieldSize: CGFloat          = 60
    static let activeReminderCellSize: CGFloat  = 90
    static let activeReminderOffset: CGFloat    = Constant.activeReminderCellSize/4
    static let offset: CGFloat                  = Constant.inputFieldSize/4
    static let compassSize: CGFloat             = Constant.buttonBarHeight
    static let compassCornerRadius: CGFloat     = Constant.buttonBarHeight/2
    static let cellPadding: CGFloat             = Constant.inputFieldSize/8
    static let arrowOffset: CGFloat             = 14
}

struct PlaceHolderText {
    static let title: String              = "Enter Reminder Title"
    static let message: String            = "Enter short message for your Reminder"
    static let latitude: String           = "Latitude"
    static let longitude: String          = "Longitude"
    static let location: String           = "Start typing to search for location"
//    static let unknownLocation: String    = "Unknown Location"
//    static let locationLatitude: String   = "Enter latitude to show location"
//    static let locationLongitude: String  = "Enter longitude to show location"
    static let bubbleColor: String        = "Bubble Color"
    static let defaultRadius: String      = "50m"
}

struct ToggleText {
    static let leavingTrigger: String   = "Trigger when leaving Bubble"
    static let enteringTrigger: String  = "Trigger when entering Bubble"
    static let isRepeating: String      = "Repeat Reminder"
    static let isNotRepeating: String   = "Use Once"
}
