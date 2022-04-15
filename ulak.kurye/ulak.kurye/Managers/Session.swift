//
//  Session.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit

enum UserState {
    case locationPermissionRequired
    case accountNotVerified
    case notWorking
    case working
}

final class Session {
    public static let shared = Session()
    
    var userState: UserState = .locationPermissionRequired
    
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
    
    var isUserWorking: Bool = false {
        didSet {
            UserDefaults.standard.setValue(isUserWorking, forKey: Constants.DefaultsKeys.isUserWorking)
            checkUserState()
        }
    }
    
    var isAccountVerified: Bool {
        return user?.isVerifiedAccount ?? false
    }
    
    var isPoolAvailable: Bool {
        return userState == .working
    }
    
    //TODO: bu tarz user bilgilerini userManager yapıp oraya taşı
    var maxOrderCount: Int {
        return user?.maxOrderCount ?? 0
    }
    
    var user: User? {
        didSet {
            checkUserState()
            updateOnesignalId()
        }
    }
    
    var oneSignalId: String? {
        didSet {
            updateOnesignalId()
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
        isUserWorking = UserDefaults.standard.bool(forKey: Constants.DefaultsKeys.isUserWorking)
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
        } else if isUserWorking {
            newUserState = .working
        } else {
            newUserState = .notWorking
        }
        
        if self.userState != newUserState {
            self.userState = newUserState
            NotificationCenter.default.post(name: NSNotification.Name.UserStateChanged, object: nil)
        }
    }
    
    private func updateOnesignalId() {
        guard let user = user else { return }
        if (user.oneSignalId == oneSignalId) { return }
        
        API.updateNotificationId(oneSignalId: oneSignalId) { result in
            switch result {
            case Result.success(_):
                self.user?.oneSignalId = self.oneSignalId
                Log.d("OnesignalId updated: \(self.oneSignalId ?? "")")
                break
            case Result.failure(let error):
                Log.e("OnesignalId update error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    // MARK: - Notifications
    @objc private func didBecomeActive() {
        self.checkUserState()
    }
    
    // MARK: - Auth
    func logout() {
        token = nil
        user = nil
    }
}
