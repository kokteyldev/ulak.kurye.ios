//
//  OrderActionCVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import UIKit

final class OrderActionCVC: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Data
    func setAction(_ action: OrderAction) {
        titleLabel.text = action.title
        //TODO: change background and textColor
    }
}
