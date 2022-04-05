//
//  Paginate.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 1.03.2022.
//

import Foundation

struct Paginate: Codable {
    let page: Int
    let pagesTotal: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case pagesTotal = "pagesTotal"
    }
    
    init() {
        page = 1
        pagesTotal = 2
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        pagesTotal = try container.decode(Int.self, forKey: .pagesTotal)
    }
}
