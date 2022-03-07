//
//  Auth.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

struct Token: Codable {
    var tokenString: String
}

struct LoginResponse: Codable {
    var tokenString: String?
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case tokenString = "token"
        case user = "user"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if container.contains(.tokenString) {
            self.tokenString = try? container.decode(String.self, forKey: .tokenString)
        }
        
        if container.contains(.user) {
            self.user = try? container.decode(User.self, forKey: .user)
        }
    }
}
