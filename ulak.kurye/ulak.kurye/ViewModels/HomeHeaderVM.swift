//
//  HomeHeaderVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import Foundation
import UIKit

struct HomeHeaderVM {
    var workTitle: String?
    var isSwitchOn: Bool
    var workAvailable: Bool
    var poolAvailable: Bool
    var qrCodeAvailable: Bool
    
    var poolBackgroundColor: UIColor {
        return poolAvailable ? UIColor(named: "ulk-orange")! : UIColor(named: "ulk-input-border")!
    }
    
    var qrCodeBackgroundColor: UIColor {
        return qrCodeAvailable ? UIColor(named: "ulk-orange")! : UIColor(named: "ulk-input-border")!
    }
    
    var poolAlpha: Double {
        return poolAvailable ? 1.0 : 0.4
    }
    
    var qrCodeAlpha: Double {
        return qrCodeAvailable ? 1.0 : 0.4
    }
    
    // MARK: - View Lifecycle
    init() {
        let userState = Session.shared.userState
        let isUserWorking = Session.shared.isUserWorking
        
        workTitle = isUserWorking ? "working".localized : "start_work".localized
        isSwitchOn = isUserWorking
        
        workAvailable = (userState == .notWorking || userState == .working)
        poolAvailable = (userState == .working)
        qrCodeAvailable = (userState == .working)
    }
}
