//
//  GetOrderResponse.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

struct GetOrderResponse: Codable {
    var orders: [Order] = []
    var paginate: Paginate = Paginate()
    
    enum CodingKeys: String, CodingKey {
        case orders = "collection"
        case paginate = "paginate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.orders) {
            self.orders = try container.decode([Order].self, forKey: .orders)
        }
        
        if container.contains(.paginate) {
            self.paginate = try container.decode(Paginate.self, forKey: .paginate)
        }
    }
}
