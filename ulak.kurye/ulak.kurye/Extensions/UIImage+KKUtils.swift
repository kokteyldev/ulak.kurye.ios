//
//  UIImage+KKUtils.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 25.02.2022.
//

import UIKit

extension UIImage {
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
}
