//
//  UITableView+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import UIKit

extension UITableView {
    func setAndLayoutTableHeaderView(header: UIView) {
        self.tableHeaderView = header
        self.tableHeaderView?.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            header.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
        
        header.setNeedsLayout()
        header.layoutIfNeeded()
        
        header.frame.size =  header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.tableHeaderView = header
    }
}
