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
    var estimatedDistance: Double?
    var sender: OrderPerson
    var receiver: OrderPerson
    var owner: Owner?
    var customer: Customer?
    var senderDistance: OrderDistance
    var receiverDistance: OrderDistance
    var checkpoints: [OrderCheckpoint]?
    var createdTime: String
    var startTime: String?
    var status: OrderStatus
    var package: OrderPackage?
    
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
        case estimatedDistance = "estimated_distance"
        case sender = "sender"
        case receiver = "receiver"
        case owner = "owner"
        case customer = "customer"
        case senderDistance = "sender_distance"
        case receiverDistance = "receiver_distance"
        case checkpoints = "checkpoints"
        case createdTime = "created_at"
        case startTime = "start_time"
        case status = "app_status"
        case package = "package"
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
    var addressDetail: String?
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
        case addressDetail = "address_detail"
        case name = "name"
        case surname = "surname"
        case city = "city_name"
        case district = "district_name"
        case hometown = "hometown_name"
        case latitude = "latitude"
        case longtitude = "longitude"
    }
}

struct Owner: Codable {
    var id: Int
    var name: String
    var surname: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case surname = "surname"
    }
}

struct Customer: Codable {
    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case image = "image"
    }
}

struct OrderDistance: Codable {
    var kilometers: Double
    
    enum CodingKeys: String, CodingKey {
        case kilometers = "kilometers"
    }
}

struct OrderCheckpoint: Codable {
    var date: String?
    var message: String?
    
    enum CodingKeys: String, CodingKey {
        case date = "created_at"
        case message = "message"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.date = try container.decode(String.self, forKey: .date)
        self.message = try container.decode(String.self, forKey: .message)
    }
}

struct OrderPackage: Codable {
    var price: String?
    var prepareTime: String?
    var paymentMethod: String?
    var currency: String = "TRY"
    
    enum CodingKeys: String, CodingKey {
        case price = "package_price"
        case prepareTime = "package_prepare_time"
        case paymentMethod = "package_payment_method"
        case currency = "package_currency"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.price = try? container.decode(String.self, forKey: .price)
        self.prepareTime = try? container.decode(String.self, forKey: .prepareTime)
        self.paymentMethod = try? container.decode(String.self, forKey: .paymentMethod)
        
        if container.contains(.currency) {
            self.currency = try container.decode(String.self, forKey: .currency)
        }
    }
}
