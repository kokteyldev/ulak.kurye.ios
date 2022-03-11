//
//  OrderTVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 23.02.2022.
//

import UIKit

final class OrderTVC: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var pickAddressLabel: UILabel!
    @IBOutlet weak var pickDetailLabel: UILabel!
    @IBOutlet weak var deliverAddressLabel: UILabel!
    @IBOutlet weak var deliverDetailLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    // MARK: - Data
    func setOrder(_ orderVM: OrderVM) {
        self.iconImageView.image = orderVM.iconImage
        self.pickAddressLabel.text = orderVM.pickAddress
        self.pickDetailLabel.text = orderVM.pickAddressDetail
        self.deliverAddressLabel.text = orderVM.deliverAddress
        self.deliverDetailLabel.text = orderVM.deliverAddressDetail
        self.priceLabel.text = orderVM.price
        self.serviceLabel.text = orderVM.serviceTitle
        
        self.iconImageView.alpha = orderVM.alpha
        self.pickAddressLabel.alpha = orderVM.alpha
        self.pickDetailLabel.alpha = orderVM.alpha
        self.deliverAddressLabel.alpha = orderVM.alpha
        self.deliverDetailLabel.alpha = orderVM.alpha
        self.priceLabel.alpha = orderVM.alpha
        self.serviceLabel.alpha = orderVM.alpha
        self.backgroundColor = orderVM.backgroundColor
    }
}
