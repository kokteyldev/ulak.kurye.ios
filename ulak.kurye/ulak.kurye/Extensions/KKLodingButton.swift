//
//  KKLoadingButton.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

final class KKLoadingButton: UIButton {
    private var originalButtonText: String?
    private var originalImage: UIImage?
    private var originalBackgroundImage: UIImage?
    private var activityIndicator: UIActivityIndicatorView!
    private var activityColor: UIColor = .white
    
    func startAnimation(activityColor: UIColor = .white) {
        self.activityColor = activityColor
        
        originalButtonText = self.titleLabel?.text
        originalImage = self.image(for: .normal)
        originalBackgroundImage = self.backgroundImage(for: .normal)
        
        self.setTitle("", for: .normal)
        self.setBackgroundImage(nil, for: .normal)
        self.setImage(nil, for: .normal)
        self.isUserInteractionEnabled = false
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    func stopAnimation() {
        self.setTitle(originalButtonText, for: .normal)
        self.setImage(originalImage, for: .normal)
        self.setBackgroundImage(originalBackgroundImage, for: .normal)
        self.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        self.bringSubviewToFront(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}
