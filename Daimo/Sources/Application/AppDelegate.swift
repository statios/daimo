//
//  AppDelegate.swift
//  Daimo
//
//  Created by KIHYUN SO on 2021/01/20.
//

import UIKit
import CoreData
import Then

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds).then {
      $0.backgroundColor = .white
      $0.rootViewController = SplashViewController()
      $0.makeKeyAndVisible()
    }
    
    return true
  }

  // MARK: - Core Data stack
  let persistentContainer = NSPersistentContainer(name: "Daimo").then {
    $0.loadPersistentStores { (storeDescription, error) in
      guard let error = error as NSError? else { return }
      fatalError("Unresolved error \(error), \(error.userInfo)")
    }
  }
  
  var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

}

