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
    
    private let lm = CLLocationManager()
    
    // MARK: - Initializer
    override init() {}
    
    // MARK: - Location
    func getLocationConsent() {
        if shouldAskPermission {
            lm.requestAlwaysAuthorization()
            return
        }
        
        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
    }
    
    func getLocation() {
        if CLLocationManager.locationServicesEnabled() {
            lm.delegate = self
            lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            lm.startUpdatingLocation()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.location = locValue
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        NotificationCenter.default.post(name: NSNotification.Name.UserStateChanged, object: nil)
    }
}
