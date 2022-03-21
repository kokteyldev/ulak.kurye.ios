//
//  Double+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import UIKit

extension Double {
    var localDistance: String {
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        
        let distanceInMiles = Measurement(value: self, unit: UnitLength.kilometers)
        return formatter.string(from: distanceInMiles)
    }
    
    func currencyValue(_ currencyCode: String) -> String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.locale(from: currencyCode)
        
        return currencyFormatter.string(from: self as NSNumber) ?? "0"
    }
}

