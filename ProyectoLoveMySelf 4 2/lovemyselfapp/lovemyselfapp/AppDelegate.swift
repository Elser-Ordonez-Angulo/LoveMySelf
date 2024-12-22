//
//  AppDelegate.swift
//  lovemyselfapp
//
//  Created by DAMII on 5/10/24.
//

import UIKit
import CoreData
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

    // Variable perezosa osea no existe para el proyecto hasta que sea llamado o instanciado
        lazy var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "LoveMySelf")
            container.loadPersistentStores(completionHandler:{
                (storeDescription, error)in
                if let error = error as NSError?{
                    fatalError("Modelo no cargado")
                }
            })
            return container
        }()
}

