//
//  MapView.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-16.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    
    // MARK: Actions
    @IBAction func showUser() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocations() {
        
    }
}

extension MapViewController: MKMapViewDelegate {
    
}
