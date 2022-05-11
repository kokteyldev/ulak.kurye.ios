//
//  String+Ulak.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import Foundation
import PhoneNumberKit

extension String {
    var isPhoneNumber: Bool {
        let pnkit = PhoneNumberKit()
        return pnkit.isValidPhoneNumber(self)
    }
    
    func character(atIndex: Int) -> String? {
        if self.length > 0 && atIndex < self.length {
            return String(self[index(startIndex, offsetBy: atIndex)])
        }
        
        return nil
    }
}
