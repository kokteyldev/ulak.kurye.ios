//
//  AppDelegate.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 17.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
#if DEBUG
        Log.shared.setLogLevel(logLevel: .d)
#else
        Log.shared.setLogLevel(logLevel: .e)
#endif
        
        FirebaseApp.configure()
        return true
    }
}

