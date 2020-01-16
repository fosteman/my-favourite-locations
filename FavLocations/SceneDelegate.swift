//
//  SceneDelegate.swift
//  FavLocations
//
//  Created by Tim Fosteman on 2020-01-12.
//  Copyright © 2020 Fosteman's Software Solutions LLC. All rights reserved.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // CoreData container initiaization
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores {
            (NSPersistentStoreDescription, error) in
            if let error = error {
                print("CoreData: Error occured during loading persistent stores, \(error.localizedDescription)")
            }
            else {
                print(NSPersistentStoreDescription)
            }
        }
        return container
    }()

    lazy var managedObjectContext: NSManagedObjectContext = persistentContainer.viewContext

    var window: UIWindow?

    func sceneDidBecomeActive(_ scene: UIScene) {
        let tabController = window!.rootViewController as! UITabBarController
        if let tabs = tabController.viewControllers {
            let FirstTab = tabs[0] as! UINavigationController
            let SecondTab = tabs[1] as! UINavigationController
            
            let currentLocationController = FirstTab.viewControllers.first as! CurrentLocation
            let locationsController = SecondTab.viewControllers.first as! Locations
            
            currentLocationController.managedObjectContext = managedObjectContext
            locationsController.managedObjectContext = managedObjectContext
        }
        listenForFatalCoreDataNotifications()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func listenForFatalCoreDataNotifications() {
        NotificationCenter.default.addObserver(forName: CoreDataSaveFailedNotification, object: nil, queue: OperationQueue.main, using: {
            notification in
            let message = """
    There was a fatal error in the app and it cannot continue.

    Press OK to terminate the app. Sorry for the inconvenience.
    """
            let alert = UIAlertController(title: "Internal Error", message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default, handler: {
                _ in let exception = NSException(name: NSExceptionName.internalInconsistencyException, reason: "Fatal Core Data error", userInfo: nil)
                exception.raise()
            })
            alert.addAction(action)
            self.window!.rootViewController!.present(alert, animated: true, completion: nil)
        })
    }

}

