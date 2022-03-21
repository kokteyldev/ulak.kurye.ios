//
//  BaseWallet.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import Foundation

struct BaseWallet: Codable {
    var uuid: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case name = "holderTypeText"
    }
}
