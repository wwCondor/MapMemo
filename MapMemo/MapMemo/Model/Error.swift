//
//  Error.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 10/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

enum AuthorizationError: Error {
    case notificationAuthorizationDenied
    case locationAuthorizationDenied
    case locationServicesDisabled
}

extension AuthorizationError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .notificationAuthorizationDenied: return "Notification Authorization denied. You can change authorization preferences in settings."
        case .locationAuthorizationDenied:     return "Location Authorization denied or restrricted. You can change authorization preferences in settings."
        case .locationServicesDisabled:        return "Woops! It seems location services are disabled. You can switch on location services in your phone settings under Privacy. Would you like to go to settings to enable location services?"
        }
    }
}

enum ReminderError: Error {
    case fetchReminder
    case unableToFetchActiveReminders
    case reminderNil
    case missingTitle
    case missingMessage 
    case missingLatitude
    case missingLongitude
    case missingLocationName
//    case invalidLatitude
//    case invalidLongitude
    case unableToObtainLocation
    case maxRemindersReached
    case titleIsDuplicate
}

extension ReminderError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .fetchReminder:                return "Unable to fetch reminder by location name"
        case .unableToFetchActiveReminders: return "Unable to retrieve active reminders from memory"
        case .reminderNil:                  return "It seems reminder is nil"
        case .missingTitle:                 return "Woops! You forgot to add a title to your reminder"
        case .missingMessage:               return "Woops! You forgot to add a message to your reminder"
        case .missingLatitude:              return "Woops! You forgot to enter a value for the latitude"
        case .missingLongitude:             return "Woops! You forgot to enter a value for the longitude"
        case .missingLocationName:          return "Woops! The location you entered has no location name"
//        case .invalidLatitude:              return "Woops! You entered an invalid value for latitude "
//        case .invalidLongitude:             return "Woops! You entered an invalid value for longitude"
        case .unableToObtainLocation:       return "Unable to obtain a location name for the coordinates you entered"
        case .maxRemindersReached:          return "Maximum active reminders (20) reached. You need to delete a reminder first"
        case .titleIsDuplicate:             return "Unable to save reminder. Reminder title already exists."
        }
    }
}

enum NotificationError: Error {
    case alertSettingNotEnabled
    case unableToAddNotificationRequest
}

extension NotificationError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .alertSettingNotEnabled:           return "Notification alerts disabled. This can be changed in phone settings"
        case .unableToAddNotificationRequest:   return "Unable to add the notification request"
        }
    }
}

enum NetworkingError: Error {
    case noConnection
}

extension NetworkingError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .noConnection:                 return "There is no internet connection."
        }
    }
}
