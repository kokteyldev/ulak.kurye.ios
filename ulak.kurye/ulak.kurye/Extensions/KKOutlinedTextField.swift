//
//  KKOutlinedTextField.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

final class KKOutlinedTextField: UITextField {
    
    @IBInspectable public var localizedTitleKey: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = NSLocalizedString(newValue ?? "", comment: "")
            setupTitle()
        }
    }
    
    @IBInspectable public var localizedPlaceholderKey: String? {
        get {
            return self.placeholder
        }
        set {
            placeholder = NSLocalizedString(newValue ?? "", comment: "")
        }
    }
    
    @IBInspectable public var title: String? {
        didSet {
            titleLabel.text = title
            setupTitle()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            setupRightView()
        }
    }
    
    private let activeborderView = UIView()
    private let titleLabel = UILabel()
    
    private var textPadding = UIEdgeInsets(
        top: 0,
        left: 12,
        bottom: 0,
        right: 12
    )
    
    private let borderColor = UIColor(named: "ulk-input-border")
    private let invalidBorderColor = UIColor(named: "ulk-red")
    private let titleColor = UIColor(named: "ulk-input-title")
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        textColor = .black
        tintColor = .black
        borderStyle = .none
        font = .init(name: "Poppins-Bold", size: 18)
        
        addSubview(activeborderView)
        sendSubviewToBack(activeborderView)
        
        addSubview(titleLabel)
        bringSubviewToFront(titleLabel)
        
        activeborderView.layer.borderWidth = 2.0
        activeborderView.layer.borderColor = borderColor?.cgColor
        
        activeborderView.layer.cornerRadius = 5
        activeborderView.backgroundColor = .white
        activeborderView.isUserInteractionEnabled = false
        
        titleLabel.font = .init(name: "Poppins-Regular", size: 11)
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .center
        titleLabel.backgroundColor = .white
        
        setupTitle()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        activeborderView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        activeborderView.translatesAutoresizingMaskIntoConstraints = false
        
        activeborderView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        activeborderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        activeborderView.heightAnchor.constraint(equalToConstant: frame.size.height).isActive = true
        activeborderView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0, constant: 0).isActive = true
        
        setNeedsDisplay()
    }
    
    private func setupTitle() {
        titleLabel.sizeToFit()
        titleLabel.frame = .init(x: 12, y: -titleLabel.frame.size.height/2, width: titleLabel.frame.size.width + 6.0, height: titleLabel.frame.size.height)
    }
    
    func setupRightView() {
        if let image = rightImage {
            rightViewMode = .always
            
            let imageView = UIImageView()
            imageView.image = image
            rightView = imageView
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
    }
    
    // MARK: - Orientation
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupUI()
    }
    
    // MARK: - Form
    func invalidate() {
        activeborderView.layer.borderColor = invalidBorderColor?.cgColor
        titleLabel.textColor = invalidBorderColor
    }
    
    func validate() {
        self.activeborderView.layer.borderColor = borderColor?.cgColor
        titleLabel.textColor = titleColor
    }
}

extension KKOutlinedTextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= textPadding.right
        return textRect
    }
}
