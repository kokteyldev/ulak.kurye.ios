//
//  UIView+Ulak.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 2.06.2022.
//

import UIKit

extension UIView {
    func strokeBorder() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.mask = maskLayer
        
        let line = NSNumber(value: Float(self.bounds.width / 2))
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineDashPattern = [line]
        borderLayer.lineDashPhase = self.bounds.width / 4
        borderLayer.lineWidth = 10
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
}
