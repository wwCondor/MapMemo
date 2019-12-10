//
//  MapMemoStub.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import CoreLocation

struct MapMemoStub {
    let title: String
    let body: String
    let coordinate: Coordinate
    var radius: Int
    var trigger: RegionTrigger
    let locationId: String
    var iIsActive: Bool // Reminders become reusable as user can re-activate reminder after use
}

struct Coordinate {
    var longitude: Double
    var lattitude: Double
}

enum RegionTrigger {
    case whenEnteringRegion
    case whenLeavingRegion
    case whenEnteringAndLeavingRegion
}

enum BorderColor {
    case blue
    case black
    case red
    case yellow
    case green
    
    var name: String {
        switch self {
        case .blue:   return "BlueBorder"
        case .black:  return "BlackBorder"
        case .red:    return "RedBorder"
        case .yellow: return "YellowBorder"
        case .green:  return "GreenBorder"
        }
    }
}



