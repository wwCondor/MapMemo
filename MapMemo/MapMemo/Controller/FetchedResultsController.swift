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
        // We call this anytime we want insertions, deletions and cell selection to be animated simultaneously
        // When we use this we also need to sue endUpdates()
        tableView.beginUpdates()
    }
    
    // This method notifies the receiver that a FetchObject has been changed and indicates the type of the change
    // Here we have the five arguments; the controller in charge of the change, the object, indexPath of changed object, the type, and the new indexpatch
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        // The type here is an enum on which we can switch on the type of change that occured
        switch type {
            
        // If we have an insert operation bu no indexPath we cant do anything, so we return
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
    
    // When any changes are made in the contex whether its a save, update, move or delete operation, the context notifies the fetchedResultsController, which then informas its delegate.
    // Here we implement the relevant delegate method and all we're doing once a change occurs is asking the tableView to reload the data
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //        tableView.reloadData() // removing this makes tapping the delete button do nothing, we're adding that back in using a different delegate method (see the one above)
        
        // With this we inform the tableView that we're done with our updates and it can go ahead and perform animations
        tableView.endUpdates()
    }
}
