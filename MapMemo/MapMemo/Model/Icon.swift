//
//  Icon.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

enum Icon {
    case activeReminderIcon
    case addIcon
    case backIcon
    case deleteIcon
    case saveIcon
    case compassIcon
    case settingsIcon
    case arrowIcon

    var name: String {
        switch self {
        case .activeReminderIcon:    return "ActiveRemindersIcon"
        case .addIcon:               return "AddIcon"
        case .backIcon:              return "BackIcon"
        case .deleteIcon:            return "DeleteIcon"
        case .saveIcon:              return "SaveIcon"
        case .compassIcon:           return "CompassIcon"
        case .settingsIcon:          return "SettingsIcon"
        case .arrowIcon:             return "ArrowIcon"
        }
    }
}
