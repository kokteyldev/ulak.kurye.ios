//
//  Paginate.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 1.03.2022.
//

import Foundation

struct Paginate: Codable {
    let page: Int
    let limit: Int
    let recordsTotal: Int
    let pagesTotal: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case limit = "limit"
        case recordsTotal = "recordsTotal"
        case pagesTotal = "pagesTotal"
    }
    
    init() {
        page = 1
        //TODO: limit ve records total gerekli mi?
        limit = 15
        recordsTotal = 16
        pagesTotal = 2
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        page = try container.decode(Int.self, forKey: .page)
        limit = try container.decode(Int.self, forKey: .limit)
        recordsTotal = try container.decode(Int.self, forKey: .recordsTotal)
        pagesTotal = try container.decode(Int.self, forKey: .pagesTotal)
    }
}
