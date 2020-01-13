//
//  FirstViewController.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-12.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController, CLLocationManagerDelegate {
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
    
    //MARK: Actions
    
    @IBAction func getLocation() {
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .denied {
            showLocationServicesDeniedAlert()
            return
        } else if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        
        startLocationManager()
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
        let newLocation = locations.last
        print("didUpdateLocation \(newLocation)")
        location = newLocation
        lastLocationError = nil
        updateLabels()
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
    }
    
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
            updatingLocation = true
        }
    }
    
    func stopLocationManager() {
        if updatingLocation {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            updatingLocation = false
        }
    }

}

