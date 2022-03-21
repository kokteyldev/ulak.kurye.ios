//
//  WalletResponse.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import Foundation

struct WalletResponse: Codable {
    var wallet: Wallet
    var transactions: [WalletTransaction] = []
    
    enum CodingKeys: String, CodingKey {
        case wallet = "wallet"
        case transactions = "transactions"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.wallet = try container.decode(Wallet.self, forKey: .wallet)
        
        if container.contains(.transactions) {
            self.transactions = try container.decode([WalletTransaction].self, forKey: .transactions)
        }
    }
}
