//
//  OnboardingView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

final class OnboardingView: UIView {
    @IBOutlet weak var LBLTitle: UILabel!
    @IBOutlet weak var LBLDescription: UILabel!
    @IBOutlet weak var IMGSOnboard: UIImageView!
    
    var title: String!
    var desc: String!
    var image: UIImage!
    
    // MARK: - View Lifecycle
    init(title: String?, description: String?, image: UIImage?, frame: CGRect) {
        super.init(frame: frame)
        self.title = title
        self.desc = description
        self.image = image
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
        loadAndAttachView()
        
        LBLTitle.text = self.title
        LBLDescription.text = self.desc
        IMGSOnboard.image = self.image
    }
    
    // MARK: - Action
    @IBAction func continueTapped(_ sender: Any) {
        Session.shared.isOnboardingSeen = true
        PreLoginVC.presentAsRoot()
    }
}
