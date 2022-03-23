//
//  OrderActionCVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import UIKit
import KokteylUtils

final class OrderActionCVC: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: KKUIView!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Data
    func setAction(_ action: OrderAction) {
        titleLabel.text = action.title
        containerView.backgroundColor = UIColor.init(hex: action.color) ?? .init(named: "ulk-red")!
        titleLabel.textColor = UIColor.init(hex: action.textColor) ?? .white
    }
}
