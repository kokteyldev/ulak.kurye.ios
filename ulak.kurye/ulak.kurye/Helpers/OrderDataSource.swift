//
//  OrderDataSource.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import Foundation

final class OrderDataSource {
    var activeOrders: [OrderVM] {
        if Session.shared.userState == .working {
            return orders
        }
        
        return []
    }
    
    private var orders: [OrderVM] = []
    
    // MARK: Initializer
    init() {
        
    }
    
    // MARK: - Order
    func addNewOrders(_ newOrders: [Order]) {
        for order in newOrders {
            orders.append(OrderVM(order: order))
        }
    }
}
