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
    
    var isDataAvailable: Bool {
        if Session.shared.userState != .working && Session.shared.userState != .notWorking {
            return false
        }
        
        return orders.count > 0 || pastOrders.count > 0
    }
    
    var shouldRequestMorePast: Bool {
        return pastPaginate.page > 0 && pastPaginate.page < pastPaginate.pagesTotal
    }
    
    var pastOrders: [OrderVM] = []
    private var pastPaginate: Paginate = Paginate()
    
    private var orders: [OrderVM] = []
    
    
    // MARK: Initializer
    init() {}
    
    // MARK: - Order
    func addNewOrders(_ newOrders: [Order]) {
        for order in newOrders {
            orders.append(OrderVM(order: order))
        }
    }
    
    func addNewPastOrders(_ orderResponse: GetOrderResponse) {
        pastPaginate = orderResponse.paginate
        
        for order in orderResponse.orders {
            pastOrders.append(OrderVM(order: order))
        }
    }
}
