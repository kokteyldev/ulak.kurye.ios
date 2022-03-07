//
//  OrderDetailVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 7.03.2022.
//

import UIKit

class OrderDetailVM: OrderVM {
    let pageTitle: String
    let orderCode: String?
    
    // MARK: Init
    override init(order: Order) {
        pageTitle = "order_detail_title".localized
        orderCode = order.code
        super.init(order: order)
    }
}
