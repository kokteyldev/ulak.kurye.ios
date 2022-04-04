//
//  SystemNotification.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 31.03.2022.
//

import Foundation

struct SystemNotification: Codable {
    var uuid: String
    var type: Int
    var data: SystemNotificationData
    var createdAt: String

    enum CodingKeys: String, CodingKey {
        case uuid = "uuid"
        case type = "notification_type"
        case data = "data"
        case createdAt = "created_at"
    }
}

struct SystemNotificationData: Codable {
    var body: SystemNotificationBody

    enum CodingKeys: String, CodingKey {
        case body = "notification"
    }
}

struct SystemNotificationBody: Codable {
    var title: String
    var body: String

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case body = "body"
    }
}
