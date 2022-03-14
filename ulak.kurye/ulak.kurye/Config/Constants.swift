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
        static let googleMapsKey = "AIzaSyBa2-fRghCvB2VlhcVXwK37nyPC20RqsTQ"
        //TODO: Kurye başvuru adresi nedir?
        static let courierApplicationURL = "https://ulakapp.com/"
    }

    struct API {
        static let apiURL = "API_URL".configValue!
        static let apiKey = "2VOtB_Z8OAbQjNdSxgx+YZlEMbtUM1vL-tnSibCJIbIGJBUf"
    }
    
    struct DefaultsKeys {
        static let token = "com.ulak.kurye.userDefaults.token"
        static let isOnboardingSeen = "com.ulak.kurye.userDefaults.isOnboardingSeen"
        static let isUserWorking = "com.ulak.kurye.userDefaults.isUserWorking"
    }
    
    static var languageCode: String {
        return Locale.current.languageCode ?? "tr"
    }
    
    static var serverDateFormat: String {
        return "dd/MM/yyyy HH:mm:ss"
    }
    
    static var longServerDateFormat: String {
        return "yyyy-MM-dd'T'HH:mm:ss.000000Z"
    }
    
    static let errorDomain = "com.ulak.kurye"
}

extension Notification.Name {
    public static var UserStateChanged: Notification.Name { return self.init("com.ulak.notification.userStateChanged") }
    public static var GoToPool: Notification.Name { return self.init("com.ulak.notification.goToPool") }
    public static var ReloadOrders: Notification.Name { return self.init("com.ulak.notification.reloadOrders") }
    
    //TODO: bunları kullan
    public static var WillEnterForeground: Notification.Name { return self.init("com.ulak.notification.willEnterForeground") }
    public static var DidEnterBackground: Notification.Name { return self.init("com.ulak.notification.didEnterBackground") }
}
