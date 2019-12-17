//
//  Color.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import UIKit

// For storing Colors as string to CoreData
enum Color {
    case bubbleRed
    case bubbleYellow
    case bubbleBlue

    var name: String {
        switch self {
        case .bubbleRed:      return "BubbleRed"
        case .bubbleYellow:   return "BubbleYellow"
        case .bubbleBlue:     return "BubbleBlue"
        }
    }
}

// Used for colors that dont need saving
extension UIColor {
    struct Name: RawRepresentable {
        typealias RawValue = String

        var rawValue: RawValue

        var name: String { return rawValue}

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        init(name: String) {
            self.init(rawValue: name)
        }
    }

    convenience init?(named: Name) {
        self.init(named: named.name)
    }
}

extension UIColor.Name {
    static let appBackgroundColor = UIColor.Name(name: "AppBackgroundColor")
    static let objectColor = UIColor.Name(name: "ObjectColor")
    static let tintColor = UIColor.Name(name: "TintColor")
}

//struct ColorSet {
//    static let appBackgroundColor: UIColor = UIColor(named: Color.appBackground.name)!
//    static let objectColor: UIColor = UIColor(named: Color.objectColor.name)!
//    static let tintColor: UIColor = UIColor(named: Color.tint.name)! // icon and text
//}
