//
//  AppDelegate.swift
//  Studie_Buddy_app
//
//  Created by Jordy Twisk on 12/11/2019.
//  Copyright © 2019 ProjectGroep5. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        window = UIWindow()
//        window?.makeKeyAndVisible()
        
//        let layout = UICollectionViewFlowLayout()
//        let buddySwipeController = BuddySwipeController(collectionViewLayout: layout)
//        layout.scrollDirection = .horizontal
        
//        window?.rootViewController = buddySwipeController
        
        UITabBar.appearance().tintColor = UIColor(red: 235.0/255.0, green: 0.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


        
    lazy var persistenceContainer: NSPersistentContainer = {
        
            let container = NSPersistentContainer(name: "Buddyconnection")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("unresolved error: \(error), \(error.userInfo)")
                }
            })
            return container
        }()
    
    func saveContext () {
        let context = persistenceContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            }catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
