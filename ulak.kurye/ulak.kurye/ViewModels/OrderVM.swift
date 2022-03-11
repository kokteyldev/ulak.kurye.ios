//
//  OrderVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import UIKit

class OrderVM {
    let isPackagePicked: Bool
    
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
        
        let isOrderActive = (order.status == .running)
        let isPackagedDelivered = (order.endTime != nil && order.endTime!.length > 0)
        isPackagePicked = order.startTime != nil && order.startTime!.length > 0
        
        let expectedStartDate = order.createdTime.serverDate?.addMinutes(order.service.expPickingTime) ?? Date()
        let expectedDeliverDate = order.createdTime.serverDate?.addMinutes(order.service.expDeliveryTime) ?? Date()
        
        let startDateString = expectedStartDate.shortDateString
        let endDateString = expectedDeliverDate.shortDateString
        
        var remainingPickMinutes: Int?
        var remainingDeliverMinutes: Int?
        
        if isOrderActive && !isPackagePicked {
            remainingPickMinutes = Date.minutesBetween(start: expectedStartDate, end: Date())
            let remainingTimeString = remainingPickMinutes!.remainingTimeString
            
            let pickDistance = order.senderDistance.kilometers
            let pickDistanceString = pickDistance.localDistance
            
            pickAddressDetail = "\(startDateString) (\(remainingTimeString)) (\(pickDistanceString))"
        } else {
            pickAddressDetail = startDateString
        }
        
        if isOrderActive && !isPackagedDelivered {
            remainingDeliverMinutes = Date.minutesBetween(start: expectedDeliverDate, end: Date())
            let remainingDeliverTimeString = remainingDeliverMinutes!.remainingTimeString
            deliverAddressDetail = "\(endDateString) (\(remainingDeliverTimeString))"
        } else {
            deliverAddressDetail = endDateString
        }
        
        backgroundColor = .white
        iconImage = .init(named: "ic-package")!
        
        if isOrderActive && !isPackagedDelivered {
            if isPackagePicked {
                if remainingDeliverMinutes ?? 0 < 0 {
                    backgroundColor = .init(named: "ulk-red")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-package-passed")!
                } else if remainingDeliverMinutes ?? 0 < 5 {
                    backgroundColor = .init(named: "ulk-orange")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-package-passed")!
                }
            } else {
                if remainingPickMinutes ?? 0 < 0 {
                    backgroundColor = .init(named: "ulk-red")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-package-passed")!
                } else if remainingPickMinutes ?? 0 < 5 {
                    backgroundColor = .init(named: "ulk-orange")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-package-passed")!
                }
            }
        }
        
        pickAddress = "\(order.sender.district)/\(order.sender.hometown)"
        deliverAddress = "\(order.receiver.district)/\(order.receiver.hometown)"
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.locale(from: order.service.currency)
        price = currencyFormatter.string(from: order.cost as NSNumber) ?? "-"
        
        serviceTitle = order.service.title
        alpha = (order.status == .running) ? 1.0 : 0.4
    }
}
