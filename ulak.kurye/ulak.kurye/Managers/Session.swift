//
//  Session.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit

enum UserState {
    case locationPermissionRequired
    case notificationPermissionRequired
    case accountNotVerified
    case notWorking
    case working
}

final class Session {
    public static let shared = Session()
    
    var userState: UserState = .notificationPermissionRequired
    
    var token: String? {
        didSet {
            UserDefaults.standard.setValue(token, forKey: Constants.DefaultsKeys.token)
        }
    }
    
    var isOnboardingSeen: Bool = false {
        didSet {
            UserDefaults.standard.setValue(isOnboardingSeen, forKey: Constants.DefaultsKeys.isOnboardingSeen)
        }
    }
    
    var isUserActive: Bool = false {
        didSet {
            UserDefaults.standard.setValue(isUserActive, forKey: Constants.DefaultsKeys.isUserActive)
            checkUserState()
        }
    }
    
    var isAccountVerified: Bool {
        return user?.isVerifiedAccount ?? false
    }
    
    var user: User? {
        didSet {
            checkUserState()
        }
    }
    
    var config: Config
    
    var isUserLoggedIn: Bool {
        return token != nil
    }

    // MARK: - Initializer
    func start(_ config: Config) {
        self.config = config
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    init() {
        token = UserDefaults.standard.string(forKey: Constants.DefaultsKeys.token)
        isOnboardingSeen = UserDefaults.standard.bool(forKey: Constants.DefaultsKeys.isOnboardingSeen)
        config = Config()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - User
    func checkUserState() {
        guard let user = user else { return }

        var newUserState = UserState.locationPermissionRequired
        
        if LocationManager.shared.isLocationPermissionRequired {
            newUserState = .locationPermissionRequired
        } else if user.isVerifiedAccount == false {
            newUserState = .accountNotVerified
        } else if isUserActive {
            newUserState = .working
        } else {
            newUserState = .notWorking
        }
        
        NotificationManager.shared.isLocationPermissionRequired { isRequired in
            if isRequired {
                newUserState = .notificationPermissionRequired
            }
            
            if self.userState != newUserState {
                self.userState = newUserState
                NotificationCenter.default.post(name: NSNotification.Name.UserStateChanged, object: nil)
            }
        }
    }
    
    // MARK: - Notifications
    @objc private func didBecomeActive() {
        self.checkUserState()
    }
    
    // MARK: - Auth
    func logout() {
        //TODO: doldur
    }
}
