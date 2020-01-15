//
//  Location+CoreDataProperties.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-15.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var date: Date
    @NSManaged public var locationDescription: String
    @NSManaged public var placemark: CLPlacemark?
    @NSManaged public var category: String

}
