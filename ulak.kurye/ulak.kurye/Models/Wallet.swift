//
//  Wallet.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import Foundation

struct Wallet: Codable {
    var uuid: String
    var balance: String
    var currency: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case balance = "balanceFloat"
        case currency = "currency"
    }
}

struct WalletTransaction: Codable {
    var uuid: String
    var meta: WalletTransactionMeta
    var type: String
    var amount: String
    var currency: String = "TRY"
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case meta = "meta"
        case type = "type"
        case amount = "amount"
        case currency = "currency"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.uuid = try container.decode(String.self, forKey: .uuid)
        self.meta = try container.decode(WalletTransactionMeta.self, forKey: .meta)
        self.type = try container.decode(String.self, forKey: .type)
        self.amount = try container.decode(String.self, forKey: .amount)
        
        if container.contains(.currency) {
            self.currency = try container.decode(String.self, forKey: .currency)
        }
        
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
    }
}

struct WalletTransactionMeta: Codable {
    var orderUUID: String?
    
    enum CodingKeys: String, CodingKey {
        case orderUUID = "order_uuid"
    }
}
