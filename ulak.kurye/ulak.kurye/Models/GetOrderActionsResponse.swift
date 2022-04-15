//
//  GetOrderActionsResponse.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

struct GetOrderActionsResponse: Codable {
    var actions: [OrderAction] = []
    
    enum CodingKeys: String, CodingKey {
        case actions = "courier_actions"
    }
}
