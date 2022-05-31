//
//  OrderVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 2.03.2022.
//

import UIKit

class OrderVM {
    let order: Order
    let isPoolOrder: Bool
    let isPackagePicked: Bool
    
    var backgroundColor = UIColor.white
    var iconImage: UIImage?
    var iconURL: URL?
    var pickAddress: String?
    var pickAddressDetail: String?
    var deliverAddress: String?
    var deliverAddressDetail: String?
    var packagePrice: String?
    var packagePrepareTime: String?
    var packagePaymentMethod: String?
    var priceTitle: String?
    var price: String?
    var serviceTitle: String?
    var estimatedDistance: String
    var alpha = 1.0
    var isNotRestaurantOrder: Bool
    
    // MARK: Init
    init(order: Order) {
        self.order = order
        self.isPoolOrder = (order.status == .active)
        self.isPackagePicked = order.startTime != nil && order.startTime!.length > 0
        
        let isOrderActive = (order.status != .closed)
        let isPackagedDelivered = (order.endTime != nil && order.endTime!.length > 0)
        
        let expectedPrepareTime = Int(order.package?.prepareTime ?? "\(order.service.expPickingTime)") ?? order.service.expPickingTime
        let expectedStartDate = order.createdTime.serverDate?.addMinutes(expectedPrepareTime) ?? Date()
        let expectedDeliverDate = order.createdTime.serverDate?.addMinutes(order.service.expDeliveryTime) ?? Date()
        
        let startDateString = expectedStartDate.shortDateString
        let endDateString = expectedDeliverDate.shortDateString
        
        var remainingPickMinutes: Int?
        var remainingDeliverMinutes: Int?
        
        if isOrderActive && !isPackagePicked {
            remainingPickMinutes = Date.minutesBetween(start: Date(), end: expectedStartDate)
            let remainingTimeString = remainingPickMinutes!.remainingTimeString
            
            let pickDistance = order.senderDistance.kilometers
            let pickDistanceString = pickDistance.localDistance
            
            pickAddressDetail = "\(startDateString) (\(remainingTimeString)) (\(pickDistanceString))"
        } else {
            pickAddressDetail = startDateString
        }
        
        if isOrderActive && !isPackagedDelivered {
            remainingDeliverMinutes = Date.minutesBetween(start: Date(), end: expectedDeliverDate)
            let remainingDeliverTimeString = remainingDeliverMinutes!.remainingTimeString
            deliverAddressDetail = "\(endDateString) (\(remainingDeliverTimeString))"
        } else {
            deliverAddressDetail = endDateString
        }
        
        backgroundColor = .white

        isNotRestaurantOrder = order.customer?.brand == nil || order.customer?.imageURL == nil || order.package == nil
        
        let logoName = isNotRestaurantOrder ? "package" : "restaurant"
        iconImage = .init(named: "ic-\(logoName)")!
        
        if isOrderActive && !isPackagedDelivered {
            if isPackagePicked {
                if remainingDeliverMinutes ?? 0 < 0 {
                    backgroundColor = .init(named: "ulk-red")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-\(logoName)-passed")!
                } else if remainingDeliverMinutes ?? 0 < 5 {
                    backgroundColor = .init(named: "ulk-orange")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-\(logoName)-passed")!
                }
            } else {
                if remainingPickMinutes ?? 0 < 0 {
                    backgroundColor = .init(named: "ulk-red")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-\(logoName)-passed")!
                } else if remainingPickMinutes ?? 0 < 5 {
                    backgroundColor = .init(named: "ulk-orange")!.withAlphaComponent(0.22)
                    iconImage = .init(named: "ic-\(logoName)-passed")!
                }
            }
        }
        
        if let imageURL = order.customer?.imageURL {
            iconURL = URL(string: imageURL)
        }
        
        pickAddress = "\(order.sender.hometown)/\(order.sender.district)/\(order.sender.city)"
        deliverAddress = "\(order.receiver.hometown)/\(order.receiver.district)/\(order.receiver.city)"
   
        if let package = order.package, let price = package.price {
            let priceDouble = Double(price)
            let price = priceDouble?.currencyValue(package.currency)
            packagePrice = "\(price ?? "0")"
            packagePaymentMethod = order.package?.paymentMethod
            packagePrepareTime = (order.package?.prepareTime ?? "") + "order_detail_package_prepare_time_remaining".localized
        }
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale.locale(from: order.service.currency)
        
        priceTitle = "order_total_price".localized
        price = currencyFormatter.string(from: order.cost as NSNumber) ?? "-"
        
        serviceTitle = order.service.title
        
        var distance: Double = (order.estimatedDistance ?? 0) / 1000
        distance = Double(round(10 * distance) / 10)
        estimatedDistance = "\(distance) km"
        
        alpha = (order.status != .closed) ? 1.0 : 0.4
    }
}
