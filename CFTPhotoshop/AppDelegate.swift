//
//  AppDelegate.swift
//  CFTPhotoshop
//
//  Created by Aleksandr X on 25.02.18.
//  Copyright © 2018 Khlebnikov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    do {
      try CoreDataManager.shared.saveContext()
    } catch {
      print("Context saving error")
    }
  }
}

