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
            NotificationCenter.default.post(name: NSNotification.Name.UserStateChanged, object: nil)
        }
    }
    
    var user: User?
    var config: Config
    
    var isUserLoggedIn: Bool {
        return token != nil
    }

    // MARK: - Initializer
    func start(_ config: Config) {
        self.config = config
        checkUserState()
        
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
        // check location permission
        if LocationManager.shared.isLocationPermissionRequired {
            userState = .locationPermissionRequired
            return
        }
        
        let group = DispatchGroup()
        //check notification permission
        group.enter()
        NotificationManager.shared.isLocationPermissionRequired { isRequired in
            if isRequired {
                self.userState = .notificationPermissionRequired
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if self.userState == .notificationPermissionRequired { return }
            
            // check account state
            if self.user?.isVerifiedAccount == false {
                self.userState = .accountNotVerified
                return
            }
            
            // check working state
            if self.isUserActive {
                self.userState = .working
            } else {
                self.userState = .notWorking
            }
        }
    }
    
    // MARK: - Notifications
    @objc private func didBecomeActive() {
        self.checkUserState()
        //TODO: check user state and post notification if needed.
    }
    
    // MARK: - Auth
    func logout() {
        //TODO: doldur
    }
}
