//
//  OrderDataSource.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import Foundation

final class OrderDataSource {
    var activeOrderVMs: [OrderVM] {
        if Session.shared.userState == .working {
            return orderVMs
        }
        
        return []
    }
    
    var isDataAvailable: Bool {
        if Session.shared.userState != .working && Session.shared.userState != .notWorking {
            return false
        }
        
        return activeOrderVMs.count > 0 || pastOrderVMs.count > 0
    }
    
    var pastOrderVMs: [OrderVM] = []
    private var orderVMs: [OrderVM] = []
    
    // MARK: Initializer
    init() {}
    
    // MARK: - New Data
    func resetOrders() {
        orderVMs.removeAll()
        pastOrderVMs.removeAll()
        
        addNewOrders(OrderManager.shared.activeOrders)
        addNewPastOrders(OrderManager.shared.pastOrders)
    }
    
    func addNewOrders(_ newOrders: [Order]) {
        for order in newOrders {
            orderVMs.append(OrderVM(order: order))
        }
    }
    
    func addNewPastOrders(_ newPastOrders: [Order]) {
        for order in newPastOrders {
            pastOrderVMs.append(OrderVM(order: order))
        }
    }
    
    // MARK: - Utils
    func order(indexPath: IndexPath) -> OrderVM {
        if indexPath.section == 0 {
            return activeOrderVMs[indexPath.row]
        }
        
        return pastOrderVMs[indexPath.row]
    }
    
    // MARK: - UITableView
    func tableView(numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.activeOrderVMs.count
        }
        
        return self.pastOrderVMs.count
    }
}
