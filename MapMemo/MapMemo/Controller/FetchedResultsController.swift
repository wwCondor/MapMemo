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

extension FetchedResultsController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // The type here is an enum on which we can switch on the type of change that occured
        switch type {
            
        // If we have an insert operation but no indexPath we can't do anything, so we return
        case .insert: guard let newIndexPath = newIndexPath else { return }
        // If we do have an indexPath we can use (In here we can supply an argument for the type of animation we want):
        tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        case .delete: guard let indexPath = indexPath else { return }
        tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .move, .update: guard let newIndexPath = newIndexPath else { return }
        tableView.reloadRows(at: [newIndexPath], with: .automatic)
            
        @unknown default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
