//
//  NotificationsResponse.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 31.03.2022.
//

import Foundation

struct NotificationsResponse: Codable {
    var notifications: [Notifications]?
    var paginate: Paginate?

    enum CodingKeys: String, CodingKey {
        case notifications = "collection"
        case paginate = "paginate"
    }
}
