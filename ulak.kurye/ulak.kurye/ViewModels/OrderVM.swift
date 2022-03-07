//
//  OrderVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import UIKit

struct OrderVM {
    var backgroundColor: UIColor
    var iconImage: UIImage
    let fromAddress: String
    let fromAddressDetail: String
    let toAddress: String
    let toAddressDetail: String
    let price: String
    let serviceTitle: String
    let alpha: Double
    
    private var order: Order
    
    // MARK: Init
    init(order: Order) {
        self.order = order
        
        let startDate = order.createdTime.serverDate?.addingTimeInterval(TimeInterval(order.service.expPickingTime * 60)) ?? Date()
        let endDate = order.createdTime.serverDate?.addingTimeInterval(TimeInterval(order.service.expDeliveryTime * 60)) ?? Date()
        
        let remainingPickMinutes = Date.minutesBetween(start: startDate, end: Date())
        let remainingDeliverMinutes = Date.minutesBetween(start: endDate, end: Date())
        
        let isPackagePicked = order.startTime != nil && order.startTime!.length > 0
        
        backgroundColor = .white
        iconImage = .init(named: "ic-package")!
        
        if !isPackagePicked {
            if remainingPickMinutes < 5 {
                backgroundColor = .init(named: "ulk-orange")!.withAlphaComponent(0.5)
                iconImage = .init(named: "ic-package-passed")!
            } else if remainingPickMinutes < 0 {
                backgroundColor = .init(named: "ulk-red")!.withAlphaComponent(0.5)
                iconImage = .init(named: "ic-package-passed")!
            }
        } else {
            if remainingDeliverMinutes < 5 {
                backgroundColor = .init(named: "ulk-orange")!.withAlphaComponent(0.5)
                iconImage = .init(named: "ic-package-passed")!
            } else if remainingDeliverMinutes < 0 {
                backgroundColor = .init(named: "ulk-red")!.withAlphaComponent(0.5)
                iconImage = .init(named: "ic-package-passed")!
            }
        }
        
        fromAddress = "\(order.sender.district)/\(order.sender.hometown)"
        toAddress = "\(order.receiver.district)/\(order.receiver.hometown)"
        
        let startDateString = startDate.shortDateString
        
        
        let remainingTimeString = remainingPickMinutes.remainingTimeString
        
        let pickDistance = order.senderDistance.kilometers
        let pickDistanceString = pickDistance.localDistance
        
        fromAddressDetail = "\(startDateString) (\(remainingTimeString)) (\(pickDistanceString))"
        
        let endDateString = endDate.shortDateString
        let remainingDeliverTimeString = remainingDeliverMinutes.remainingTimeString
        
        toAddressDetail = "\(endDateString) (\(remainingDeliverTimeString))"
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.locale(from: order.service.currency)
        price = currencyFormatter.string(from: order.cost as NSNumber) ?? "-"
        
        serviceTitle = order.service.title
        
        alpha = (order.status == .running) ? 1.0 : 0.4
    }
}
