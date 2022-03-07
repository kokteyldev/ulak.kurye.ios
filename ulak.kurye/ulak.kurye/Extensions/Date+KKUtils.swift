//
//  Date+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import Foundation

extension Date {
    var shortDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, hh:mm"
        return dateFormatter.string(from: self)
    }
    
    static func minutesBetween(start: Date, end: Date) -> Int {
        return Int(( Int(start.timeIntervalSince1970) - Int(end.timeIntervalSince1970)) * 3600)
    }
}
