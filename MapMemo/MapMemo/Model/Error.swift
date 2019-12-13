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
    case missingTitle
//    case missingMessage // Should this be allowed to be empty?
    case missingLatitude
    case missingLongitude
}

extension ReminderError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .missingTitle:                 return "Woops! It seems you forgot to enter a title"
//        case .missingMessage:               return ""
        case .missingLatitude:              return "Woops! It seems you forgot to enter a value for the latitude"
        case .missingLongitude:             return "Woops! It seems you forgot to enter a value for the longitude"
        }
    }
}
