//
//  Locations.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-16.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class Locations: UITableViewController {
    var managedObjectContext: NSManagedObjectContext!
    
    lazy var locations: NSFetchedResultsController<Location> = {
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = Location.entity()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "category", ascending: true),
            NSSortDescriptor(key: "date", ascending: true),
        ]
        fetchRequest.fetchBatchSize = 20
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: "category", cacheName: "Locations")
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTable()
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    deinit {
        locations.delegate = nil
    }

    // MARK: - Table view data source
    func loadTable() {
        do {
            try locations.performFetch()
        }
        catch {
            fatalCoreDataError(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = locations.sections![section]
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath) as! LocationCell
        
        let location = locations.object(at: indexPath)
        
        cell.configure(for: location)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let location = locations.object(at: indexPath)
            location.removePhotoFile()
            managedObjectContext.delete(location)
            do {
                try managedObjectContext.save()
            }
            catch {
                fatalCoreDataError(error)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return locations.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = locations.sections![section]
        return sectionInfo.name
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editlocation" {
            let controller = segue.destination as! LocationDetails
            
            controller.managedObjectContext = managedObjectContext
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let location = locations.object(at: indexPath)
                controller.locationToEdit = location
            }
        }
    }
}

extension Locations: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerWillChangeContent")
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                print("*** NSFetchedResultsChangeInsert (object)")
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                print("*** NSFetchedResultsChangeDelete (object)")
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                print("*** NSFetchedResultsChangeUpdate (object)")
                if let cell = tableView.cellForRow(at: indexPath!) as? LocationCell {
                    let location = controller.object(at: indexPath!) as! Location
                    cell.configure(for: location)
                }
            case .move:
                print("*** NSFetchedResultsChangeMove (object)")
                tableView.deleteRows(at: [indexPath!], with: .fade)
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            default:
                fatalCoreDataError(fatalError("Unsupported operation Core Data"))
            }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                print("*** NSFetchedResultsChangeInsert (section)")
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                print("*** NSFetchedResultsChangeDelete (section)")
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            case .update:
                print("*** NSFetchedResultsChangeUpdate (section)")
            case .move:
                  print("*** NSFetchedResultsChangeMove (section)")
        default:
            fatalCoreDataError(fatalError("unknown method"))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("*** controllerDidChangeContent")
        tableView.endUpdates()
    }
}
