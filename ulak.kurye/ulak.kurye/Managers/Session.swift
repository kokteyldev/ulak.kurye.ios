//
//  Session.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

final class Session {
    public static let shared = Session()
    
    var token: String? {
        didSet {
            UserDefaults.standard.setValue(token, forKey: Constants.DefaultsKeys.token)
        }
    }
    
    var isOnboardingSeen: Bool = false {
        didSet {
            UserDefaults.standard.setValue(token, forKey: Constants.DefaultsKeys.isOnboardingSeen)
        }
    }
    
    //TODO: doldur
//    var user: UserModel?
//    var config: Config?
    
    var isUserLoggedIn: Bool {
        return token != nil
    }

    // MARK: - Initializer
    init() {
        token = UserDefaults.standard.string(forKey: Constants.DefaultsKeys.token)
        isOnboardingSeen = UserDefaults.standard.bool(forKey: Constants.DefaultsKeys.isOnboardingSeen)
    }
    
    // MARK: - Auth
    func logout() {
        //TODO: doldur
    }
    
    func baseURL() -> String {
        return Constants.API.apiURL
    }
}
