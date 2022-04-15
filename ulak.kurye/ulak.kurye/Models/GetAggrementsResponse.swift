//
//  GetAggrementsResponse.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

struct GetAggrementsResponse: Codable {
    var aggrements: [Agreement] = []
    var curentAggrements: [Agreement] = []
    
    enum CodingKeys: String, CodingKey {
        case aggrements = "available_agreements"
        case curentAggrements = "current_agreement"
    }
}
