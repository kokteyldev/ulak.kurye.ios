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
        
        return df.date(from: self)
    }
}
