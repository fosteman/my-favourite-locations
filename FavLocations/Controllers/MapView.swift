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

class MapView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLocations()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var managedObjectContext: NSManagedObjectContext!
    var locations = [Location]()
    
    // MARK: Actions
    @IBAction func showUser() {
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mapView.regionThatFits(region), animated: true)
    }
    
    @IBAction func showLocations() {
        
    }
    
    //MARK: helpers
    
    func updateLocations() {
        
        mapView.removeAnnotations(locations)
        
        let fetchRequest = NSFetchRequest<Location>()
        fetchRequest.entity = Location.entity()
        locations = try! managedObjectContext.fetch(fetchRequest)
        
        mapView.addAnnotations(locations)
    }
}

extension MapView: MKMapViewDelegate {
    
}
