//
//  Color.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

enum Color {
    case appBackground
    case objectColor
    case tint

    var name: String {
        switch self {
        case .appBackground:  return "AppBackgroundColor"
        case .objectColor:    return "ObjectColor"
        case .tint:           return "TintColor"
        }
    }
}

struct ColorSet {
    static let appBackgroundColor: UIColor = UIColor(named: Color.appBackground.name)!
    static let objectColor: UIColor = UIColor(named: Color.objectColor.name)!
    static let tintColor: UIColor = UIColor(named: Color.tint.name)! // icon and text
}
