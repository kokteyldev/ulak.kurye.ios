//
//  Login.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 26.04.2022.
//

import Foundation

struct Login: Codable {
    var isRegistered: Bool
    
    enum CodingKeys: String, CodingKey {
        case isRegistered = "registered"
    }
}
