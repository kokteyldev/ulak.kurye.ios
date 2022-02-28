//
//  HomeHeaderVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import Foundation
import UIKit

struct HomeHeaderVM {
    // Work settings
    var workTitle: String
    var isSwitchOn: Bool
    var isWorkEnabled: Bool
    var workAlpha: Double
    
    // Pool settings
    var poolEnabled: Bool
    var poolAlpha: Double
    var poolBackgroundColor: UIColor
    
    // QR settings
    var qrCodeEnabled: Bool
    var qrCodeAlpha: Double
    var qrCodeBackgroundColor: UIColor
    
    // MARK: - View Lifecycle
    init() {
        let userState = Session.shared.userState
        let isUserWorking = Session.shared.isUserWorking
        
        workTitle = isUserWorking ? "working".localized : "start_work".localized
        isSwitchOn = isUserWorking
        isWorkEnabled = (userState == .notWorking || userState == .working)
        workAlpha = isWorkEnabled ? 1.0 : 0.4
        
        poolEnabled = (userState == .working)
        poolAlpha = poolEnabled ? 1.0 : 0.4
        poolBackgroundColor = poolEnabled ? UIColor(named: "ulk-orange")! : UIColor(named: "ulk-input-border")!
        
        qrCodeEnabled = (userState == .working)
        qrCodeAlpha = qrCodeEnabled ? 1.0 : 0.4
        qrCodeBackgroundColor = qrCodeEnabled ? UIColor(named: "ulk-orange")! : UIColor(named: "ulk-input-border")!
    }
}
