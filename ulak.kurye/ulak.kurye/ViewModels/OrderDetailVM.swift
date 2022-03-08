//
//  OrderDetailVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 7.03.2022.
//

import UIKit

final class OrderDetailVM: OrderVM {
    let pageTitle: String
    let orderCode: String?
    let senderName: String?
    let receiverName: String?
    let packageDetail: String?
    let courierNote: String?
    
    var breakpoints: [OrderBreakpoint] {
        return order.breakpoints ?? []
    }
    
    var isPackageDetailHidden: Bool {
        return order.packageDetail == nil || order.packageDetail?.length == 0
    }
    
    var isCourierNoteHidden: Bool {
        return order.note == nil || order.note?.length == 0
    }
    
    var isBreakpointsHidden: Bool {
        return breakpoints.count == 0
    }
    
    // MARK: Init
    override init(order: Order) {
        pageTitle = "order_detail_title".localized
        orderCode = order.code
        senderName = order.sender.name + " " + (order.sender.surname ?? "")
        receiverName = order.receiver.name + " " + (order.receiver.surname ?? "")
        packageDetail = order.packageDetail
        courierNote = order.note
        
        super.init(order: order)
    }
}
