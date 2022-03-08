//
//  OrderVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import UIKit

class OrderVM {
    var backgroundColor: UIColor
    var iconImage: UIImage
    let pickAddress: String
    let pickAddressDetail: String
    let deliverAddress: String
    let deliverAddressDetail: String
    let price: String
    let serviceTitle: String
    let alpha: Double
    
    var order: Order
    
    // MARK: Init
    init(order: Order) {
        self.order = order
        
        //TODO: tarihler düzgün çalışmıyor.
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
        
        pickAddress = "\(order.sender.district)/\(order.sender.hometown)"
        deliverAddress = "\(order.receiver.district)/\(order.receiver.hometown)"
        
        let startDateString = startDate.shortDateString
        
        let remainingTimeString = remainingPickMinutes.remainingTimeString
        
        let pickDistance = order.senderDistance.kilometers
        let pickDistanceString = pickDistance.localDistance
        
        pickAddressDetail = "\(startDateString) (\(remainingTimeString)) (\(pickDistanceString))"
        
        let endDateString = endDate.shortDateString
        let remainingDeliverTimeString = remainingDeliverMinutes.remainingTimeString
        
        deliverAddressDetail = "\(endDateString) (\(remainingDeliverTimeString))"
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.locale(from: order.service.currency)
        price = currencyFormatter.string(from: order.cost as NSNumber) ?? "-"
        
        serviceTitle = order.service.title
        
        alpha = (order.status == .running) ? 1.0 : 0.4
    }
}
