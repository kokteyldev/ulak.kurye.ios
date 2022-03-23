//
//  OrderAction.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

enum OrderActionRuleType: String, CaseIterable {
    case orderUUID = "order_uuid"
    case agreementUUID = "agreement_uuid"
    case deliverSecurityCode = "delivering_security_code"
    case pickSecurityCode = "picking_security_code"
}

struct OrderActionParam: Codable {
    var rules: [String: [String]]
    
    enum CodingKeys: String, CodingKey {
        case rules = "rules"
    }
}

struct OrderActionInput: Codable {
    var params: OrderActionParam
    
    enum CodingKeys: String, CodingKey {
        case params = "params"
    }
}

struct OrderAction: Codable {
    var name: String
    var title: String
    var desc: String?
    var isDisabled: Bool
    var color: String
    var textColor: String
    var inputs: OrderActionInput
    
    var isConsentRequired: Bool {
        if self.name == "take" || self.name == "abort" {
            return true
        }
        return false
    }
    
    var consentMessage: String {
        if self.name == "take" {
            return "action_take_consent_message".localized
        } else if self.name == "abort" {
            return "action_abort_consent_message".localized
        }
        
        return ""
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case title = "title"
        case desc = "description"
        case isDisabled = "disable"
        case color = "primary_color"
        case textColor = "text_primary_color"
        case inputs = "inputs"
    }
}
