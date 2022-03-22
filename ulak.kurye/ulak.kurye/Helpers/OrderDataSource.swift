//
//  OrderDataSource.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import UIKit

final class OrderDataSource {
    var activeOrderVMs: [OrderVM] {
        if Session.shared.userState == .working {
            return orderVMs
        }
        
        return []
    }
    
    var isBackgroundViewAvailable: Bool {
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
        if !isBackgroundViewAvailable { return 0 }
        
        if section == 0 {
            return self.activeOrderVMs.count
        }
        
        return self.pastOrderVMs.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isBackgroundViewAvailable { return nil }
        
        if section == 0 {
            let headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
            headerView.titleLabel.text = "home_active_orders".localized
            return headerView
        }
        
        let headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
        headerView.titleLabel.text = "home_past_orders".localized
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isBackgroundViewAvailable ? 32.0 : 0
    }
}
