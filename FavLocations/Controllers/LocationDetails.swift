//
//  TagLocation.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-14.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

public let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class LocationDetails: UITableViewController {
    @IBOutlet weak var locationDescription: UITextView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var descriptionText = ""
    var placemark: CLPlacemark?
    var selectedCategory = "No Category"
    var dateObject = Date()
    
    var managedObjectContext: NSManagedObjectContext!
    
    var locationToEdit: Location? {
        didSet {
            if let l = locationToEdit {
                title = "Edit Location"
                descriptionText = l.locationDescription
                selectedCategory = l.category
                dateObject = l.date
                coordinate = CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude)
                placemark = l.placemark
            }
            
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            pickPhoto()
        }
    }
    
    //MARK: Actions
    @IBAction func done(_ sender: Any) {
        let delayInSeconds = 0.6
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)
        let locationToSave: Location
        
        if let t = locationToEdit {
            hudView.text = "Updated"
            locationToSave = t
        }
        else {
            hudView.text = "Tagged"
            locationToSave = Location(context: managedObjectContext)
        }
        
        locationToSave.locationDescription = locationDescription.text
        locationToSave.category = selectedCategory
        locationToSave.latitude = coordinate.latitude
        locationToSave.longitude = coordinate.longitude
        locationToSave.date = dateObject
        locationToSave.placemark = placemark
        
        do {
            try managedObjectContext.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds, execute: {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            })
        }
        catch {
            fatalCoreDataError(error)
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: Auxillary
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationDescription.text = descriptionText
        category.text = selectedCategory
        latitude.text = String(format: "%.8f", coordinate.latitude)
        longitude.text = String(format: "%.8f", coordinate.longitude)
        
        address.text = (placemark != nil) ? string(from: placemark!) : "No Address Found"
        
        date.text = format(date: dateObject)
    
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Target-action pattern
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    //MARK: Helpers
    
    @objc func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if let indexPath = indexPath,
            indexPath.section == 0,
            indexPath.row == 0 {
            return // in case if the text view is tapped.
        }
        else {
            locationDescription.resignFirstResponder()
        }
    }
    
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

extension LocationDetails: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        }
        else {
            choosePhoto()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default) {
            _ in
            self.takePhoto()
        }
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default) {
            _ in
            self.choosePhoto()
        }
        
        alert.addAction(actCancel)
        alert.addAction(actPhoto)
        alert.addAction(actLibrary)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func choosePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
