//
//  Int+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import Foundation

extension Int {
    var remainingTimeString: String {
        if self <= -60*24 {
            return "no_time_remaining".localized
        }
        
        if self < 0 {
            return "\(abs(self)) " + "order_minutes_late".localized
        } else if self < 60 {
            return "\(self) " + "remaining_minutes".localized
        } else if self < 60*24 {
            return "\(Int(self/60)) " + "remaining_hours".localized
        }
        
        return "\(Int(self/1440))" + "remaining_days".localized
    }
}
