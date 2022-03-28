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
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case meta = "meta"
        case type = "type"
        case createdAt = "created_at"
    }
}

struct WalletTransactionMeta: Codable {
    var orderUUID: String
    var prepayEarning: WalletTransactionEarning?
    var earning: WalletTransactionEarning?
    
    enum CodingKeys: String, CodingKey {
        case orderUUID = "order_uuid"
        case prepayEarning = "courier_prepay_earning"
        case earning = "courier_pay_earning"
    }
}

struct WalletTransactionEarning: Codable {
    var value: Double
    var currency: String
    var isVisible: Bool
    
    enum CodingKeys: String, CodingKey {
        case value = "value"
        case currency = "currency"
        case isVisible = "visible"
        //TODO: status'a bakmak gerekli mi?
    }
}
