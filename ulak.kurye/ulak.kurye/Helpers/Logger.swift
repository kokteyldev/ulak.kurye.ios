//
//  Logger.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import Foundation

enum LogLevel: Int {
    case n = 0  // none
    case e = 1  // error
    case i = 2  // info
    case d = 3  // debugr
    
    var prefix: String {
        switch self {
        case .n:
            return ""
        case .e:
            return "[E]"
        case .i:
            return "[I]"
        case .d:
            return "[D]"
        }
    }
}

final class Log {
    static let shared = Log()
    
    private var logPrefix: String = "<ULAK>"
    private(set) var logLevel: LogLevel
    
    // MARK: - Initializer
    
    init() {
        #if targetEnvironment(simulator)
        self.logLevel = .d
        #else
        self.logLevel = .i
        #endif
    }
    
    // MARK: - Config
    
    func setLogLevel(logLevel: LogLevel) {
        self.logLevel = logLevel
    }
    
    func setLogPrefix(logPrefix: String) {
        self.logPrefix = logPrefix
    }
    
    // MARK: - Log
    
    class func e(_ object: Any) {
        if Log.shared.logLevel == .n { return }
        Log.shared.log(logLevel: .e, message: "\(object)")
    }
    
    class func i(_ object: Any) {
        if Log.shared.logLevel.rawValue < LogLevel.i.rawValue { return }
        Log.shared.log(logLevel: .i, message: "\(object)")
    }
    
    class func d(_ object: Any) {
        if Log.shared.logLevel.rawValue < LogLevel.d.rawValue { return }
        Log.shared.log(logLevel: .d, message: "\(object)")
    }
    
    fileprivate func log(logLevel: LogLevel, message: String) {
        let prefix = "\(self.logPrefix) \(logLevel.prefix):"
        print("\(prefix) \(message)")
    }
}
