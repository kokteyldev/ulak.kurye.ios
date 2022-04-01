//
//  Notifications.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 31.03.2022.
//

import Foundation

struct Notifications: Codable {
    var uuid: String
    var type: Int

    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case type = "notification_type"
    }
}
