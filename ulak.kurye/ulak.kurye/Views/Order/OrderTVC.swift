//
//  OrderTVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 23.02.2022.
//

import UIKit

final class OrderTVC: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var fromDetailLabel: UILabel!
    @IBOutlet weak var toAddressLabel: UILabel!
    @IBOutlet weak var toDetailLabel: UILabel!
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
        self.fromAddressLabel.text = orderVM.fromAddress
        self.fromDetailLabel.text = orderVM.fromAddressDetail
        self.toAddressLabel.text = orderVM.toAddress
        self.toDetailLabel.text = orderVM.toAddressDetail
        self.priceLabel.text = orderVM.price
        self.serviceLabel.text = orderVM.serviceTitle
    }
}
