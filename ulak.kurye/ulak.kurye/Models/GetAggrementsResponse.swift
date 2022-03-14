//
//  GetAggrementsResponse.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

struct GetAggrementsResponse: Codable {
    var aggrements: [Agreement] = []
    
    enum CodingKeys: String, CodingKey {
        case aggrements = "available_agreements"
    }
}
