//
//  OrderAction.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

struct OrderAction: Codable {
    var name: String
    var title: String
    var desc: String?
    var isDisabled: Bool
    var color: String
    var textColor: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case title = "title"
        case desc = "description"
        case isDisabled = "disable"
        case color = "primary_color"
        case textColor = "text_primary_color"
    }
}
