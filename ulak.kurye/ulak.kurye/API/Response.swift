//
//  Response.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

struct Response<T: Codable>: Codable {
    var meta: ResponseMeta
    var data: T?
    
    public init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        meta = try keyedContainer.decode(ResponseMeta.self, forKey: CodingKeys.meta)
        data = try? keyedContainer.decode(T.self, forKey: CodingKeys.data)
    }
    
    private enum CodingKeys: String, CodingKey {
        case meta = "meta"
        case data = "data"
    }
}

struct ResponseMeta: Codable {
    var flag: String
    var code: Int
    var message: String?
}
