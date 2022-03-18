//
//  String+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import Foundation

extension String {
    var serverDate: Date? {
        let df = DateFormatter()
        df.dateFormat = Constants.serverDateFormat
        
        if let date = df.date(from: self) {
            return date
        }
        
        df.dateFormat = Constants.longServerDateFormat
        return df.date(from: self)
    }
    
    var encrypted: String {
        if let first = self.first {
            return "\(first)***"
        }
        return ""
    }
}
