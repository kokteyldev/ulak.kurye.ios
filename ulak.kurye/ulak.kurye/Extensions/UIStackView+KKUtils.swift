//
//  UIStackView+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 8.03.2022.
//

import UIKit

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }
}
