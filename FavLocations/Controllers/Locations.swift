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
    var locations = [Location]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = Location.entity()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            locations = try managedObjectContext.fetch(fetchRequest)
        }
        catch {
            fatalCoreDataError(error)
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return locations.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
        let descriptionLabel = cell.viewWithTag(11) as! UILabel
        let addressLabel = cell.viewWithTag(12) as! UILabel
        let location = locations[indexPath.row]
        
        descriptionLabel.text = location.locationDescription
        if let placemark = location.placemark
        {
            var text = ""
            if let s = placemark.subThoroughfare {text += s + " " }
            if let s = placemark.thoroughfare {text += s + ", "}
            if let s = placemark.locality {text += s }
            addressLabel.text = text
        }
        else {addressLabel.text = "" }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
