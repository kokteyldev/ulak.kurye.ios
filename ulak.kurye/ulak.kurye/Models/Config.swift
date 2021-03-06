//
//  Config.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

struct Config: Codable {
    var latestVersion: String
    var kvvkURL: ServerURL?
    var phoneNumber: String
    var registerURL: String?
    
    private var policies: [ServerURL]
    
    enum CodingKeys: String, CodingKey {
        case latestVersion = "ios"
        case courier = "courier"
        case appVersion = "app_version"
        case policyDict = "static_pages"
        case phoneNumber = "service_phone_number"
        case registerURL = "courier_onboarding_link"
    }
    
    init() {
        self.latestVersion = "0"
        self.policies = []
        self.phoneNumber = ""
        self.registerURL = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let appVersion = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .appVersion)
        let courier = try appVersion.nestedContainer(keyedBy: CodingKeys.self, forKey: .courier)
        
        latestVersion = try courier.decode (String.self, forKey: .latestVersion)
        
        policies = try container.decode([ServerURL].self, forKey: .policyDict)
        
        phoneNumber = try container.decode(String.self, forKey: .phoneNumber)
        registerURL = try? container.decode(String.self, forKey: .registerURL)
        
        var kvkkURLModel: ServerURL?
        
        for policy in policies {
            if policy.key == "kvkk" {
                kvkkURLModel = policy
            }
        }
        
        guard let kvkkURLModel = kvkkURLModel else {
            throw CustomError.errorWithMessage(message: "Invalid config")
        }
        
        kvvkURL = kvkkURLModel
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        var appVersion = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .appVersion)
        var courier = appVersion.nestedContainer(keyedBy: CodingKeys.self, forKey: .courier)
        try courier.encode(self.latestVersion, forKey: .latestVersion)
    }
}
