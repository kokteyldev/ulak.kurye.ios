//
//  User.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

struct User: Codable {
    var name: String?
    var surname: String?
    var email: String?
    var phoneNumber: String
    var isVerifiedAccount: Bool
    var maxOrderCount: Int
    var cardNumber: String?
    var wallets: [BaseWallet] = []
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case surname = "surname"
        case email = "email"
        case phoneNumber = "phone_number"
        case isVerifiedAccount = "is_confirmed"
        case maxOrderCount = "total_task_quotas"
        case cardNumber = "ininal_card_number"
        case wallets = "wallets"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.name) {
            self.name = try? container.decode(String.self, forKey: .name)
        }
        
        if container.contains(.surname) {
            self.surname = try? container.decode(String.self, forKey: .surname)
        }
        
        if container.contains(.email) {
            self.email = try? container.decode(String.self, forKey: .email)
        }
        
        phoneNumber = try container.decode (String.self, forKey: .phoneNumber)
        
        if container.contains(.isVerifiedAccount) {
            self.isVerifiedAccount = try container.decode(Bool.self, forKey: .isVerifiedAccount)
        } else {
            self.isVerifiedAccount = false
        }
        
        maxOrderCount = try container.decode (Int.self, forKey: .maxOrderCount)
        cardNumber = try? container.decode (String.self, forKey: .cardNumber)
        
        if container.contains(.wallets) {
            self.wallets = try container.decode([BaseWallet].self, forKey: .wallets)
        }
    }
}
