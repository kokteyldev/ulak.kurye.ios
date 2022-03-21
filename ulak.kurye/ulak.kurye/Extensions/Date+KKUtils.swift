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
    
    var longDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy | hh:mm"
        return dateFormatter.string(from: self)
    }
    
    func addMinutes(_ minutes: Int) -> Date {
        return self.addingTimeInterval(TimeInterval(minutes * 60))
    }
    
    static func minutesBetween(start: Date, end: Date) -> Int {
        let diff = Calendar.current.dateComponents([.minute], from: start, to: end).minute ?? 0

        if start.timeIntervalSince1970 < end.timeIntervalSince1970 {
            return diff * -1
        }
        
        return diff
    }
}
