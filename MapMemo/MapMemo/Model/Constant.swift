//
//  Constant.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

struct Constant {
    static let buttonBarHeight: CGFloat = 60 // height of buttons/buttonbars
    static let largeTextInset: CGFloat  = 6
    static let smallTextInset: CGFloat  = 2
    static let borderWidth: CGFloat     = 2
    static let inputFieldSize: CGFloat  = 85
    static let offset: CGFloat          = Constant.inputFieldSize/4
}

struct PlaceHolderText {
    static let title: String              = "Enter Reminder Title"
    static let message: String            = "Enter short message for your Reminder"
    static let latitude: String           = "Enter Latitude"
    static let longitude: String          = "enter Longitude"
    static let location: String           = "Enter latitude and longitude to show location"
    static let locationLatitude: String   = "Enter latitude to show location"
    static let locationLongitude: String  = "Enter longitude to show location"
    static let bubbleColor: String        = "Bubble Color"
//    static let bubbleRadius: String     = "Bubble Radius: 50m"
}

struct ToggleText {
    static let leavingTrigger: String   = "Trigger Reminder when leaving Bubble"
    static let enteringTrigger: String  = "Trigger Reminder when entering Bubble"
    static let isRepeating: String      = "Repeat Reminder"
    static let isNotRepeating: String   = "Use Reminder once"
}
