//
//  OrderManager.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import Foundation

final class OrderManager {
    public static let shared = OrderManager()

    var activeOrders: [Order] = []
    var pastOrders: [Order] = []
    
    private var pastPaginate: Paginate = Paginate()
    
    var activeOrderCount: Int {
        return activeOrders.count
    }
    
    var shouldRequestMorePast: Bool {
        return pastPaginate.page > 0 && pastPaginate.page < pastPaginate.pagesTotal
    }
    
    // MARK: - Init
    init() {
        
    }
    
    deinit {
        
    }
    
    // MARK: - Data
    func getOrders(completion: @escaping(Result<Bool, Error>) -> Void) {
        let group = DispatchGroup()
        var apiError: Error?
        
        activeOrders.removeAll()
        pastOrders.removeAll()
        pastPaginate = Paginate()
        
        group.enter()
        API.getOrders(status: OrderStatus.running.rawValue) { result in
            switch result {
            case Result.success(let orderResponse):
                self.activeOrders = orderResponse.orders
                group.leave()
                break
            case Result.failure(let error):
                apiError = error
                group.leave()
                break
            }
        }
        
        group.enter()
        API.getOrders(status: OrderStatus.closed.rawValue) { result in
            switch result {
            case Result.success(let orderResponse):
                self.pastPaginate = orderResponse.paginate
                self.pastOrders = orderResponse.orders
                group.leave()
                break
            case Result.failure(let error):
                apiError = error
                group.leave()
                break
            }
        }
        
        group.notify(queue: .main) {
            if let apiError = apiError {
                completion(.failure(apiError))
            } else {
                completion(.success(true))
            }
        }
    }
    
    func getMoreOrders(completion: @escaping(Result<[Order], Error>) -> Void) {
        if !shouldRequestMorePast {
            completion(.success([]))
            return
        }
        
        API.getOrders(status: OrderStatus.closed.rawValue) { result in
            switch result {
            case Result.success(let orderResponse):
                self.pastPaginate = orderResponse.paginate
                self.pastOrders.append(contentsOf: orderResponse.orders)
                completion(.success(orderResponse.orders))
                break
            case Result.failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
    // MARK: - Actions
    func didTakeAction(order: Order) {
        activeOrders.insert(order, at: 0)
        NotificationCenter.default.post(name: NSNotification.Name.ReloadOrders, object: nil)
    }
}