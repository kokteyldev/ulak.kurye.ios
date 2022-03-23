//
//  NoDataView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.03.2022.
//  Copyright © 2021 Kokteyl. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isLoading: Bool = false {
        didSet {
            setupUI()
        }
    }
    
    // MARK: - View Lifecycle
    convenience init(title: String, message: String, image: UIImage) {
        self.init()
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.imageView.image = image
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
        loadAndAttachView()
    }
    
    // MARK: - Setup
    func setupUI() {
        self.titleLabel.isHidden = isLoading
        self.messageLabel.isHidden = isLoading
        self.imageView.isHidden = isLoading
        self.activityIndicator.isHidden = !isLoading
        
        if isLoading {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }

}
