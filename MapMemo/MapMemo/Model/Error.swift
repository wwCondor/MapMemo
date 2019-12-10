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
}

extension AuthorizationError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .notificationAuthorizationDenied: return "Notification Authorization denied. You can change authorization preferences in settings."
        case .locationAuthorizationDenied:     return "Location Authorization denied. You can change authorization preferences in settings."
        }
    }
}
