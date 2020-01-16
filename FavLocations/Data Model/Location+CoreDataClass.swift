//
//  Location+CoreDataClass.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-15.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit
import CoreLocation

@objc(Location)
public class Location: NSManagedObject, MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(latitude, longitude)
    }

    public var title: String? {
        return locationDescription.isEmpty ? "(No Description)" : locationDescription
    }
    
    public var subtitle: String?  {
        return category
    }
}
