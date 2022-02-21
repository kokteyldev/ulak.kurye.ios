//
//  APILogger.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

class APILogger {
    
    // MARK: - Properties
    
    private static var isLogEnabled: Bool {
        return Log.shared.logLevel == .d
    }
    
    // MARK: - Log
    
    class func log(_ route: APIRouter) {
        guard isLogEnabled else { return }
        
        Log.d(route.logString())
    }
}
