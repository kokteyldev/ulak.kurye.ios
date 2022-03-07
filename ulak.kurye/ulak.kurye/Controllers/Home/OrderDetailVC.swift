//
//  OrderDetailVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 7.03.2022.
//

import UIKit

class OrderDetailVC: BaseVC {
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var serviceInfoLabel: UILabel!
    
    var order: Order?
    var viewModel: OrderDetailVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    func setupUI() {
        //TODO: show no order alert and go back if order is nil
        guard let order = order else { return }
        viewModel = OrderDetailVM(order: order)
        
        self.title = viewModel?.pageTitle
        orderCodeLabel.text = viewModel?.orderCode
        serviceInfoLabel.text = viewModel?.serviceTitle
    }
}
