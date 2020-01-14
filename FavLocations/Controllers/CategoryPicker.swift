//
//  Category.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-14.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import Foundation
import UIKit

class CategoryPicker: UITableViewController {
    var categorySelection = ""
    var rowSelection =  IndexPath()
    
    let categories = [
        "No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Historic Building",
        "House",
        "Icecream Vendor",
        "Landmark",
    "Park"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for (i, category) in categories.enumerated() {
            if category == categorySelection {
                rowSelection = IndexPath(row: i, section: 0)
                break
            }
        }
    }
    
    // MARK: Table View Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        
        let categoryName = categories[indexPath.row]
        cell.textLabel!.text = categoryName
        
        if categoryName == categorySelection {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != rowSelection.row {
            if let newCell = tableView.cellForRow(at: indexPath) {
                newCell.accessoryType = .checkmark
            }
            
            if let oldCell = tableView.cellForRow(at: rowSelection) {
                oldCell.accessoryType = .none
            }
            
            rowSelection = indexPath
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "categorypick" {
            let cell = sender as! UITableViewCell
            
            if let indexPath = tableView.indexPath(for: cell) {
                categorySelection = categories[indexPath.row]
            }
        }
    }
}

