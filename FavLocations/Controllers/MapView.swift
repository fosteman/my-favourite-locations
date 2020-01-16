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
        if !locations.isEmpty {
            showLocations()
        }
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
        let theRegion = region(for: locations)
        mapView.setRegion(theRegion, animated: true)
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
    func region(for annotations: [MKAnnotation]) -> MKCoordinateRegion {
        let region: MKCoordinateRegion
        
        switch annotations.count {
        case 0:
            region = MKCoordinateRegion(
                center: mapView.userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        case 1:
            let annotation = annotations[annotations.count - 1]
            region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        default:
            var topLeft = CLLocationCoordinate2D(latitude: -90, longitude: 180)
            var bottomRight = CLLocationCoordinate2D(latitude: 90, longitude: -180)
            for annotation in annotations {
                topLeft.latitude = max(topLeft.latitude, annotation.coordinate.latitude)
                topLeft.longitude = min(topLeft.longitude, annotation.coordinate.longitude)
                bottomRight.latitude = min(bottomRight.latitude, annotation.coordinate.latitude)
                bottomRight.longitude = max(bottomRight.longitude, annotation.coordinate.longitude)
            }
                let center = CLLocationCoordinate2D(latitude: topLeft.latitude - (topLeft.latitude - bottomRight.latitude) / 2, longitude: topLeft.longitude - (topLeft.longitude - bottomRight.longitude) / 2)
                
                let extraSpace = 1.1
                let span = MKCoordinateSpan(latitudeDelta: abs(topLeft.latitude - bottomRight.latitude) * extraSpace, longitudeDelta: abs(topLeft.longitude - bottomRight.longitude) * extraSpace)
            
                region = MKCoordinateRegion(center: center, span: span)
        }
                return mapView.regionThatFits(region)
    }
}