//
//  LoadingView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit
import KokteylUtils

final class LoadingView: UIView {
    var message: String?
    private var isDark: Bool = true
    
    private var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.8
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }()
    
    // MARK: - View Lifecycle
    init(message: String?, frame: CGRect, isDark: Bool = true) {
        super.init(frame: frame)
        self.message = message
        self.isDark = isDark
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if isDark == true {
            backgroundColor = UIColor.black.withAlphaComponent(0.5)
            blurEffectView.frame = self.bounds
            insertSubview(blurEffectView, at: 0)
        } else {
            backgroundColor = .clear
        }
        
        // ImageView
        let animatedImageView = KKAnimatedImageView(frame: .init(x: 0, y: 0, width: 60, height: 60))
        animatedImageView.imageName = "logo-gif"
        animatedImageView.frameCount = 26
        animatedImageView.duration = 2
        animatedImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animatedImageView)
        
        NSLayoutConstraint(item: animatedImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: animatedImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 60).isActive = true
        NSLayoutConstraint(item: animatedImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: animatedImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        
        // Message
        if let message = message {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 0
            messageLabel.lineBreakMode = .byWordWrapping
            messageLabel.font = .init(name: "Poppins-Regular", size: 15)
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            messageLabel.textColor = .white
            addSubview(messageLabel)
            
            NSLayoutConstraint(item: messageLabel, attribute: .top, relatedBy: .equal, toItem: animatedImageView, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
            
            NSLayoutConstraint(item: messageLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: messageLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        }
        
        animatedImageView.startAnimation()
    }
    
    // MARK: - Action
    func show(from fromVC: UIViewController, message: String? = nil) {
        self.message = message
        fromVC.view.addSubview(self)
        fromVC.view.bringSubviewToFront(self)
    }
    
    func close() {
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }
    }
}

