//
//  ServerURL.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

struct ServerURL: Codable {
    var url: String
    var key: String?
    var title: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
        case key = "key"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        url = try container.decode(String.self, forKey: .url)
        key = try? container.decode(String.self, forKey: .key)
        title = try container.decode(String.self, forKey: .title)
    }
}
