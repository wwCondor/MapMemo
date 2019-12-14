//
//  FetchedResultsController.swift
//  MapMemo
//
//  Created by Wouter Willebrands on 14/12/2019.
//  Copyright © 2019 Studio Willebrands. All rights reserved.
//

import CoreData
import UIKit

class FetchedResultsController: NSFetchedResultsController<Reminder> {
    // Object responsible for performing fetch on the entries
    private let tableView: UITableView
    
    init(managedObjectContext: NSManagedObjectContext, tableView: UITableView, request: NSFetchRequest<Reminder>) {
        self.tableView = tableView
        super.init(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)

        tryFetch()
    }
    
    func tryFetch() {
        do {
            try performFetch()
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }
}
