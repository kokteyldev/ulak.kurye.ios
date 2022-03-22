//
//  LocationManager.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 24.02.2022.
//

import Foundation
import MapKit

final class LocationManager: NSObject {
    public static let shared = LocationManager()
    
    var location = CLLocationCoordinate2D(latitude: 41.0349, longitude: 28.9481)
    
    var isLocationPermissionRequired: Bool {
        if #available(iOS 14.0, *) {
            return lm.authorizationStatus != .authorizedAlways
        } else {
            return CLLocationManager.authorizationStatus() != .authorizedAlways
        }
    }
    
    private var shouldAskPermission: Bool {
        if #available(iOS 14.0, *) {
            return lm.authorizationStatus == .notDetermined
        } else {
            return CLLocationManager.authorizationStatus() == .notDetermined
        }
    }
    
    private var timer: Timer?
    private var lastUpdateTimestamp: TimeInterval?
    private let lm = CLLocationManager()
    
    // MARK: - Initializer
    override init() {}
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged), name: .UserStateChanged, object: nil)
        self.userStateChanged()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UserStateChanged, object: nil)
        timer?.invalidate()
    }
    
    // MARK: - Data
    private func updateLocation() {
        if let lastUpdateTimestamp = lastUpdateTimestamp,
           lastUpdateTimestamp + Constants.App.locationUpdateInterval >= Date().timeIntervalSince1970 {
            return
        }
        
        self.lastUpdateTimestamp = Date().timeIntervalSince1970
        
        let batteryLevel = Double(UIDevice.current.batteryLevel) * 100.0
        API.updateLocation(lat: location.latitude, lng: location.longitude, batteryLevel: batteryLevel, accuracy: 10.0) { result in
            switch result {
            case Result.success(_):
                Log.d("Location updated!")
                break
            case Result.failure(let error):
                Log.e("Location update error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    // MARK: - Location
    func getLocationConsent() {
        if shouldAskPermission {
            lm.requestAlwaysAuthorization()
            return
        }
        
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    private func startMonitoring() {
        if CLLocationManager.locationServicesEnabled() {
            lm.delegate = self
            lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            lm.allowsBackgroundLocationUpdates = true
            lm.pausesLocationUpdatesAutomatically = false
            lm.startUpdatingLocation()
            
            UIDevice.current.isBatteryMonitoringEnabled = true
            timer = Timer.scheduledTimer(timeInterval: Constants.App.locationUpdateInterval,
                                         target: self,
                                         selector: #selector(timerTicked),
                                         userInfo: nil,
                                         repeats: true)
            updateLocation()
        }
    }
    
    private func stopMonitoring() {
        lm.stopUpdatingLocation()
        UIDevice.current.isBatteryMonitoringEnabled = false
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Notifications
    @objc private func userStateChanged() {
        if Session.shared.isUserLoggedIn &&
            Session.shared.userState != .notWorking &&
            Session.shared.userState != .accountNotVerified {
            startMonitoring()
        } else {
            stopMonitoring()
        }
    }
    
    @objc func timerTicked() {
        self.updateLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last?.coordinate else { return }
        self.location = newLocation
        self.updateLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Session.shared.checkUserState()
    }
}
