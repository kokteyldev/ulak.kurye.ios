//
//  Order.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 28.02.2022.
//

import Foundation

enum OrderStatus: String, Codable {
    case active = "active"
    case running = "running"
    case closed = "closed"
}

struct Order: Codable {
    var id: Int
    var uuid: String
    var code: String?
    var packageDetail: String?
    var takeTime: String?
    var endTime: String?
    var serviceId: Int
    var service: OrderService
    var weight: Double
    var note: String?
    var cost: Double
    var sender: OrderPerson
    var receiver: OrderPerson
    var senderDistance: OrderDistance
    var receiverDistance: OrderDistance
    var breakpoints: [OrderBreakpoint]?
    var createdTime: String
    var startTime: String?
    var status: OrderStatus
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case uuid = "uuid"
        case code = "code"
        case packageDetail = "package_detail"
        case takeTime = "take_time"
        case endTime = "end_time"
        case serviceId = "service_id"
        case service = "service"
        case weight = "volumetric_weight"
        case note = "note_for_courier"
        case cost = "cost"
        case sender = "sender"
        case receiver = "receiver"
        case senderDistance = "sender_distance"
        case receiverDistance = "receiver_distance"
        case breakpoints = "breakpoints"
        case createdTime = "created_at"
        case startTime = "start_time"
        case status = "app_status"
    }
}

struct OrderService: Codable {
    var title: String
    var expPickingTime: Int
    var expDeliveryTime: Int
    var currency: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case expPickingTime = "expected_picking_time"
        case expDeliveryTime = "expected_delivery_time"
        case currency = "currency"
    }
}

struct OrderPerson: Codable {
    var id: Int
    var address: String
    var name: String
    var surname: String?
    var city: String
    var district: String
    var hometown: String
    var latitude: Double
    var longtitude: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case address = "address"
        case name = "name"
        case surname = "surname"
        case city = "city_name"
        case district = "district_name"
        case hometown = "hometown_name"
        case latitude = "latitude"
        case longtitude = "longitude"
    }
}

struct OrderDistance: Codable {
    var kilometers: Double
    
    enum CodingKeys: String, CodingKey {
        case kilometers = "kilometers"
    }
}

struct OrderBreakpoint: Codable {
    var name: String
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case name = "breakpoint_name"
        case date = "created_at"
    }
}
