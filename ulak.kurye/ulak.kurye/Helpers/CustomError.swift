//
//  CustomError.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

enum CustomError: Int {
    case unknownError = -1
    case noResponseData = 1
    case invalidData = 2
    case noData = 3
    
    private var message: String {
        switch self {
        case .unknownError:
            return "error_unknown".localized
        case .noResponseData:
            return "error_no_response".localized
        case .invalidData:
            return "error_invalid_data".localized
        case .noData:
            return "error_no_data".localized
        }
    }
    
    var error: Error {
        return NSError(domain: "ULAK-Kurye", code: self.rawValue, userInfo: [NSLocalizedDescriptionKey : message])
    }
    
    static func errorWithMessage(message: String?) -> Error {
        if let message = message {
            return NSError(domain: "ULAK-Kurye", code: -1, userInfo: [NSLocalizedDescriptionKey : message])
        }
        
        return CustomError.unknownError.error
    }
}
