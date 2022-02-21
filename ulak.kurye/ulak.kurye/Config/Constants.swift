//
//  Constants.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation
import KokteylUtils

struct Constants {
    struct App {
        static let appURL = "itms-apps://apple.com/app/id1610547130"
    }
    
    struct API {
        static let apiURL = "API_URL".configValue!
        static let baseURL = Session.shared.baseURL()
        static let apiKey = "2VOtB_Z8OAbQjNdSxgx+YZlEMbtUM1vL-tnSibCJIbIGJBUf"
    }
    
    struct DefaultsKeys {
        static let token = "com.ulak.kurye.userDefaults.token"
        static let isOnboardingSeen = "com.ulak.kurye.userDefaults.isOnboardingSeen"
    }
    
    static var languageCode: String {
        return Locale.current.languageCode ?? "tr"
    }
    
    static let errorDomain = "com.ulak.kurye"
}
