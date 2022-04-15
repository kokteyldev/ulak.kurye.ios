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
}
