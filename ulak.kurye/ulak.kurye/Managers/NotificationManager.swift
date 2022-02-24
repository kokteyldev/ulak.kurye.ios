//
//  NotificationManager.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 23.02.2022.
//

import UIKit
import UserNotifications

final class NotificationManager: NSObject {
    public static let shared = NotificationManager()
    
    private var authState: UNAuthorizationStatus = .notDetermined
    
    // MARK: - Initializer
    private override init() {
        super.init()
    }
    
    // MARK: - Notification
    func getNotificationConsent() {
        shouldAskNotificationPermission { shouldAsk in
            if shouldAsk {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in }
                return
            }
            
            self.openAppNotificationSettings()
        }
    }
    
    func isLocationPermissionRequired(completion: @escaping(Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            self.authState = notificationSettings.authorizationStatus
            
            if notificationSettings.authorizationStatus != .authorized {
                completion(true)
                return
            }
            
            completion(false)
        }
    }
    
    private func shouldAskNotificationPermission(completion: @escaping(Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            self.authState = notificationSettings.authorizationStatus
            
            if notificationSettings.authorizationStatus == .notDetermined {
                completion(true)
                return
            }

            completion(false)
        }
    }
    
    func openAppNotificationSettings() {
        DispatchQueue.main.async {
            if let bundleIdentifier = Bundle.main.bundleIdentifier,
                let appSettings = URL(string: UIApplication.openSettingsURLString + bundleIdentifier) {
                if UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings)
                }
            }
        }
    }
}
