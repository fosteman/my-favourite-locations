//
//  TagLocation.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-14.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import UIKit
import CoreLocation

public let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class TagLocation: UITableViewController {
    @IBOutlet weak var locationDescription: UITextView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    var placemark: CLPlacemark?
    
    var selectedCategory = "No Category"
    
    //MARK: Actions
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Auxillary
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationDescription.text = ""
        
        category.text = selectedCategory
        
        latitude.text = String(format: "%.8f", coordinate.latitude)
        longitude.text = String(format: "%.8f", coordinate.longitude)
        
        if let placemark = placemark {
            address.text = string(from: placemark)
        }
        else {
            address.text = "No Address Found"
        }
        
        date.text = format(date: Date())
    }
    
    //MARK: Helpers
    
    func string(from p: CLPlacemark) -> String {
        var text = ""
        
        if let s = p.subThoroughfare {
            text += s + " "
        }
        if let s = p.thoroughfare {
            text += s + ", "
        }
        if let s = p.locality {
            text += s + ", "
        }
        if let s = p.administrativeArea {
            text += s + " "
        }
        if let s = p.postalCode {
            text += s + ", "
        }
        if let s = p.country {
            text += s
        }
        return text
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Table view data source
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "catpicker" {
            let controller = segue.destination as! CategoryPicker
            
            controller.categorySelection = selectedCategory
        }
    }
    
    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPicker
           
        selectedCategory = controller.categorySelection // assign the selected category from source (picker)
        category.text = selectedCategory // fix the label
        

       }
}
