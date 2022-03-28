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
        
        df.dateFormat = Constants.oldServerDateFormat
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
    
    func toDictionary() -> [String:String]? {
       if let data = self.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:String]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    // MARK: - Validation
    var isValidName: Bool {
        return self.count < 3
    }
    
    var isValidSurname: Bool {
        return self.count < 3
    }
}
