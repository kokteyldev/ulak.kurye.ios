//
//  Int+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import Foundation

extension Int {
    var remainingTimeString: String {
        if self <= -60*24*7 {
            return "no_time_remaining".localized
        }
        
        if self < 0 {
            let minutes = abs(self)

            if minutes < 60 {
                return "\(minutes) " + "order_minutes_late".localized
            } else if minutes < 60*24 {
                return "\(Int(minutes/60)) " + "order_hour_late".localized
            }
            
            return "\(Int(minutes/1440)) " + "order_day_late".localized
        } else if self < 60 {
            return "\(self) " + "remaining_minutes".localized
        } else if self < 60*24 {
            return "\(Int(self/60)) " + "remaining_hours".localized
        }
        
        return "\(Int(self/1440))" + "remaining_days".localized
    }
}
