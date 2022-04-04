//
//  SystemNotificationResponse.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 31.03.2022.
//

import Foundation

struct SystemNotificationResponse: Codable {
    var notifications: [SystemNotification]?
    var paginate: Paginate?

    enum CodingKeys: String, CodingKey {
        case notifications = "collection"
        case paginate = "paginate"
    }
}
