//
//  FirstViewController.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-12.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class CurrentLocation: UIViewController, CLLocationManagerDelegate {
    //MARK: Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    var timer: Timer?
    var managedObjectContext: NSManagedObjectContext!
    
    //MARK: Actions
    
    @IBAction func getLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .denied {
            showLocationServicesDeniedAlert()
            return
        } else if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        if updatingLocation {
            stopLocationManager()
        }
        else {
            location = nil
            lastLocationError = nil
            startLocationManager()
        }
        updateLabels()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabels()
        
    }
    
    //MARK: Delegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did fail erroneously \(error.localizedDescription)")
        if (error as! CLError).code == CLError.locationUnknown {
            return
        }
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("didUpdateLocation \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 {
            return
        }
        
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        
        // Calculate distance between new and previous reading.
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        // if there's no previous reading, the greatestMagnitutde distance persist.
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("Done here")
                stopLocationManager()
                // force reverse geocoding for the final location, even if request is being performed.
                // I absolutely want an address for this final location, for it's most accurate so far.
                
                if distance > 0 {
                    // By setting false, geocoding is forced on this location.
                    performingReverseGeocoding = false
                }
                else if distance == 0 {
                    // if distance is 0, then this location is the same as previous.
                }
            }
            updateLabels()
            
            if !performingReverseGeocoding {
                print("Reverse geocoding")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(newLocation, completionHandler: {
                    placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let p = placemarks, !p.isEmpty {
                        self.placemark = p.last!
                    }
                    else {
                        self.placemark = nil
                    }
                    
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                })
            }
        }
        else if distance < 1 { // if coordinate from this reading is not significantly (1 meter) different from the previous, and, it's been more than 10 second since then, it's best to stop.
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("Force done")
                stopLocationManager()
                updateLabels()
            }
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        // ?
    }
    
    //MARK: Auxillary functions
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location services unavailalbe", message: "Please enable the services in app settings", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Go to settings", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func updateLabels() {
        if let location = location {
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isEnabled = true
            messageLabel.text = ""
            
            if let placemark = placemark {
                addressLabel.text = placemark.thoroughfare
            }
            else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address"
            }
            else if lastGeocodingError != nil {
                addressLabel.text = "Error finding Address"
            }
            else {
                addressLabel.text = "No Address Found"
            }
        }
        else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isEnabled = false
            let statusMsg: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMsg = "Location Services Disabled"
                }
                else {
                    statusMsg = "Error Getting Location"
                }
            }
                else if !CLLocationManager.locationServicesEnabled() {
                    statusMsg = "Location Services Disabled"
                }
                else if updatingLocation {
                    statusMsg = "Searching..."
                }
                else {
                    statusMsg = "Tap 'Get Location' to Start"
                }
                messageLabel.text = statusMsg
            }
        configurableGetButton()
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
            updatingLocation = true
            timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false) // didTimeOut message is sent to self after 60 seconds.
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
            if let timer = timer {
                timer.invalidate() // if accurate location was found before timer fires, or when 'Stop' button is hit.
            }
        }
    }
    
    func configurableGetButton() {
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
        }
        else {
            getButton.setTitle("Get Location", for: .normal)
        }
    }
    
    @objc func didTimeOut() { //@objc attribute identifies a method as being accessibl from Objective-C

        print("Timeout!")
        if location == nil { // if after 1 minute there's still no valid location, error is created
            stopLocationManager()
            lastLocationError = NSError(domain: "FavLocationErrorDomain", code: 1, userInfo: nil)
            updateLabels()
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taglocation" {
            let controller = segue.destination as! LocationDetails
            controller.coordinate = location!.coordinate
            controller.placemark = placemark
            controller.managedObjectContext = managedObjectContext
        }
    }
}

