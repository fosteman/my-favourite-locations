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
    
    public var hasPhoto: Bool {
        return photoID != nil
    }
    
    public var photoURL: URL {
        assert(photoID != nil, "No associated photo")
        let filename = "Photo-\(photoID!.intValue).jpg"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    public var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
}
