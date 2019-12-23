//
//  Reminder+CoreDataProperties.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 14/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//
//

import Foundation
import CoreData

extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        let request = NSFetchRequest<Reminder>(entityName: "Reminder")
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.caseInsensitiveCompare(_:)))]
        
        return request
    }

    @NSManaged public var title: String
    @NSManaged public var message: String
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var locationName: String
    @NSManaged public var triggerWhenEntering: Bool
    @NSManaged public var isRepeating: Bool
    @NSManaged public var bubbleColor: String
    @NSManaged public var bubbleRadius: Double
    @NSManaged public var isActive: Bool
}
