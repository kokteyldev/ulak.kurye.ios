//
//  AppDelegate.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 17.02.2022.
//

import UIKit
import Firebase
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupUI()
        
#if DEBUG
        Log.shared.setLogLevel(logLevel: .d)
#else
        Log.shared.setLogLevel(logLevel: .e)
#endif
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(Constants.App.googleMapsKey)
        
        return true
    }
    
    // MARK: - UI
    private func setupUI() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "ic-back")
        UINavigationBar.appearance().tintColor = .init(named: "ulk-orange")
    }
}

