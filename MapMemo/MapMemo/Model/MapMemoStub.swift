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
//    let coordinateLongitude: Double
//    let coordinateLatitude: Double
    var radius: Int
    var triggerWhenEntering: Bool // if false it will trigger when leaving instead
    let locationId: String
    var iIsActive: Bool // Reminders become reusable as user can re-activate reminder after use
    var regionBorderColor: String
}

struct Coordinate {
    var longitude: Double
    var lattitude: Double
}

//enum RegionTrigger {
//    case whenEnteringRegion
//    case whenLeavingRegion
//    case whenEnteringAndLeavingRegion
//}

enum BubbleColor {
    case blue
    case black
    case red
    case yellow
    case green
    
    var string: String {
        switch self {
        case .blue:   return "BlueBorder"
        case .black:  return "BlackBorder"
        case .red:    return "RedBorder"
        case .yellow: return "YellowBorder"
        case .green:  return "GreenBorder"
        }
    }
}



