//
//  OrderDetailVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 7.03.2022.
//

import UIKit
import CoreLocation

final class OrderDetailVM: OrderVM {
    let orderCode: String?
    let senderName: String?
    let ownerName: String?
    let receiverName: String?
    let packageDetail: String?
    let courierNote: String?
    let senderLocation: CLLocationCoordinate2D
    let receiverLocation: CLLocationCoordinate2D
    let isActionViewHeight: CGFloat
    let isDetailsHidden: Bool
    let isPastOrder: Bool
    
    var checkpoints: [OrderCheckpoint] {
        return order.checkpoints ?? []
    }
    
    var isMapButtonsActive: Bool {
        return isPastOrder
    }
    
    var mapButtonsAlpha: CGFloat {
        return (isPastOrder == false) ? 0.5 : 1.0
    }
    
    var isPackageDetailHidden: Bool {
        return isDetailsHidden || order.packageDetail == nil || order.packageDetail?.length == 0
    }
    
    var isRestaurantDetailHidden: Bool {
        return order.customer?.brand == nil || order.customer?.image == nil
    }
    
    var isPackagePriceHidden: Bool {
        return isPoolOrder || order.package == nil
    }
    
    var isCourierNoteHidden: Bool {
        return isDetailsHidden || order.note == nil || order.note?.length == 0
    }
    
    var isCheckpointsHidden: Bool {
        return checkpoints.count == 0 || order.status == .active
    }
    
    // MARK: Init
    override init(order: Order) {
        orderCode = order.code
        
        packageDetail = order.packageDetail
        courierNote = order.note
        senderLocation = .init(latitude: order.sender.latitude, longitude: order.sender.longtitude)
        receiverLocation = .init(latitude: order.receiver.latitude, longitude: order.receiver.longtitude)
        isActionViewHeight = (order.status == .closed) ? 0 : 90
        isDetailsHidden = (order.status != .running)
        isPastOrder = (order.status != .closed)
        
        if isDetailsHidden {
            senderName = order.sender.name.encrypted + " " + (order.sender.surname?.encrypted ?? "")
            receiverName = order.receiver.name.encrypted + " " + (order.receiver.surname?.encrypted ?? "")
            ownerName = (order.owner?.name.encrypted ?? "") + " " + (order.owner?.surname?.encrypted ?? "")
        } else {
            senderName = order.sender.name + " " + (order.sender.surname ?? "")
            receiverName = order.receiver.name + " " + (order.receiver.surname ?? "")
            ownerName = (order.owner?.name ?? "") + " " + (order.owner?.surname ?? "")
        }
        
        super.init(order: order)
        
        if isPastOrder {
            pickAddress = order.sender.address
            if let adressDetail = order.sender.addressDetail {
                pickAddress = "\(pickAddress ?? "") (\(adressDetail))"
            }
            
            deliverAddress = order.receiver.address
            if let adressDetail = order.receiver.addressDetail {
                deliverAddress = "\(deliverAddress ?? "") (\(adressDetail))"
            }
        }
    }
}
