//
//  OrderDataSource.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import Foundation

final class OrderDataSource {
    var activeOrders: [Any] {
        if Session.shared.userState == .working {
            return orders
        }
        
        return []
    }
    
    private var orders: [Any] = ["1", "2", "3", "4"]
    
    // MARK: Initializer
    init() {
        
    }
}
