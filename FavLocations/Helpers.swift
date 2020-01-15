//
//  Helpers.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-15.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import Foundation
import CoreData

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print(error.localizedDescription)
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}

