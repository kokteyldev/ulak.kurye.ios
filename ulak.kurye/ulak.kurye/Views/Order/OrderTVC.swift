//
//  OrderTVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 23.02.2022.
//

import UIKit
import AlamofireImage

protocol OrderTVCDelegate: AnyObject {
    func orderTVCAddTapped(_ orderTVC: OrderTVC, order: Order)
}

final class OrderTVC: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var pickAddressLabel: UILabel!
    @IBOutlet weak var pickDetailLabel: UILabel!
    @IBOutlet weak var deliverAddressLabel: UILabel!
    @IBOutlet weak var deliverDetailLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var addButton: KKLoadingButton!
    @IBOutlet weak var detailArrowImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    weak var delegate: OrderTVCDelegate?
    private var order: Order?
    
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
        self.order = orderVM.order
        
        if let url = orderVM.iconURL {
            iconImageView.af.setImage(withURL: url, placeholderImage: orderVM.iconImage)
        } else {
            iconImageView.image = orderVM.iconImage
        }
        
        self.iconImageView.image = orderVM.iconImage
        self.pickAddressLabel.text = orderVM.pickAddress
        self.pickDetailLabel.text = orderVM.pickAddressDetail
        self.deliverAddressLabel.text = orderVM.deliverAddress
        self.deliverDetailLabel.text = orderVM.deliverAddressDetail
        self.priceTitleLabel.text = orderVM.priceTitle
        self.priceLabel.text = orderVM.price
        self.serviceLabel.text = orderVM.serviceTitle
        self.distanceLabel.text = orderVM.estimatedDistance
        
        self.iconImageView.alpha = orderVM.alpha
        self.pickAddressLabel.alpha = orderVM.alpha
        self.pickDetailLabel.alpha = orderVM.alpha
        self.deliverAddressLabel.alpha = orderVM.alpha
        self.deliverDetailLabel.alpha = orderVM.alpha
        self.priceLabel.alpha = orderVM.alpha
        self.serviceLabel.alpha = orderVM.alpha
        self.distanceLabel.alpha = orderVM.alpha
        self.backgroundColor = orderVM.backgroundColor
        self.detailArrowImage.isHidden = orderVM.isPoolOrder
        self.addButton.isHidden = !orderVM.isPoolOrder
    }
    
    // MARK: - Utils
    func stopLoading() {
        DispatchQueue.main.async {
            self.addButton.stopAnimation()
        }
    }
    
    // MARK: - Actions
    @IBAction func addTapped(_ sender: Any) {
        if let order = order {
            addButton.startAnimation(activityColor: .black)
            delegate?.orderTVCAddTapped(self, order: order)
        }
    }
}
