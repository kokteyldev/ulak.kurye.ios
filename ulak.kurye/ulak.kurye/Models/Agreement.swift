//
//  Agreement.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

struct Agreement: Codable {
    var id: Int
    var uuid: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uuid = "uuid"
    }
}
