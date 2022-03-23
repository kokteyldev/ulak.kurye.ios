//
//  AppDelegate.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 17.02.2022.
//

import UIKit
import Firebase
import GoogleMaps
import OneSignal

@main
class AppDelegate: UIResponder, UIApplicationDelegate, OSSubscriptionObserver {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupUI()
        
#if DEBUG
        Log.shared.setLogLevel(logLevel: .d)
        OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
#else
        Log.shared.setLogLevel(logLevel: .e)
#endif
        FirebaseApp.configure()
        GMSServices.provideAPIKey(Constants.App.googleMapsKey)
        
        OneSignal.initWithLaunchOptions(launchOptions)
        OneSignal.setAppId("89994db6-4c19-4ed0-9218-5558dbd1ac43")
        OneSignal.add(self as OSSubscriptionObserver)
          
        return true
    }
    
    // MARK: - UI
    private func setupUI() {
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Poppins-Bold", size: 18)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "ic-back")
        UINavigationBar.appearance().tintColor = .init(named: "ulk-orange")
    }
    
    // MARK: - OSSubscriptionObserver
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges) {
        if let playerId = stateChanges.to.userId, playerId.length > 0 {
            Log.d("Onesignal playerId: \(playerId)")
            Session.shared.oneSignalId = playerId
        }
    }
}
