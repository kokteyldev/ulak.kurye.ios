//
//  PhoneHelper.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import Foundation
import PhoneNumberKit

struct Country {
    var countryCode: String // TR
    var countryName: String? // Turkiye
    var phoneCode: String // +90
    
    var flag: String {
        let base : UInt32 = 127397
        var s = ""
        for v in countryCode.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    var title: String {
        return "\(self.flag) \(self.phoneCode)"
    }
    
    init(countryCode: String, countryName: String?, phoneCode: String) {
        self.countryCode = countryCode
        self.countryName = countryName
        self.phoneCode = phoneCode
    }
}

struct PhoneHelper {
    static func getCountries() -> [Country] {
        if let path = Bundle.main.path(forResource: "countryCode", ofType: "plist") {
            if let arrayOfDictionaries = NSArray(contentsOfFile: path) {
                let countries = arrayOfDictionaries as! [[String: String]]
                
                var countryList: [Country] = []
                for countryDict in countries {
                    countryList.append(Country(
                        countryCode: countryDict["countryCode"]!,
                        countryName: countryDict["countryName"]!,
                        phoneCode: countryDict["phoneCode"]!)
                    )
                }
                
                return countryList
            }
        }
        
        return []
    }
    
    static func defaultCountry() -> Country {
        return PhoneHelper.countryForCountryCode(Constants.currentCountry)
    }
    
    static func countryForCountryCode(_ countryCode: String) -> Country {
        let countries = PhoneHelper.getCountries()
        
        for country in countries {
            if country.countryCode == countryCode {
                return country
            }
        }
        
        return countries[0]
    }
    
    // TR, 532XXXXXXX
    static func parseFullPhoneNumber(_ fullPhoneNumber: String) -> (String, String) {
        let phoneNumberKit = PhoneNumberKit()
        do {
            let phoneNumber = try phoneNumberKit.parse(fullPhoneNumber)
            return (phoneNumber.regionID ?? "TR", String(phoneNumber.nationalNumber))
        }
        catch {
            print("Generic parser error")
        }
        return (Constants.currentCountry, "")
    }
}
