//
//  MapMemoStub.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 09/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import Foundation

struct MapMemoStub {
    var mapMemoName: String
    var mapMemoMessage: String
    var mapMemoLocation: StubCoordinate
    var mapMemoTrigger: ReminderTriggerOption
    var mapMemoIsActive: Bool // Reminders become reusable as user can re-activate reminder after use
}

struct StubCoordinate {
    var longitude: Double
    var lattitude: Double
}
