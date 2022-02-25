//
//  HomeHeaderView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 23.02.2022.
//

import UIKit
import KokteylUtils

protocol HeaderViewDelegate: AnyObject {
    func poolTapped()
    func qrCodeTapped()
}

final class HomeHeaderView: UIView {
    @IBOutlet weak var workContainerView: KKUIView!
    @IBOutlet weak var poolContainerView: KKUIView!
    @IBOutlet weak var qrCodeContainerView: KKUIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var segmentControl: UISwitch!
    
    weak var delegate: HeaderViewDelegate?
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func commonInit() {
        loadAndAttachView()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged), name: .UserStateChanged, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UserStateChanged, object: nil)
    }
    
    // MARK: - Setup
    func setupUI() {
        let vm = HomeHeaderVM()
        
        DispatchQueue.main.async {
            self.lblTitle.text = vm.workTitle
            self.segmentControl.isOn = vm.isSwitchOn
            self.workContainerView.isUserInteractionEnabled = vm.workAvailable
            self.poolContainerView.isUserInteractionEnabled = vm.poolAvailable
            self.qrCodeContainerView.isUserInteractionEnabled = vm.qrCodeAvailable
            self.poolContainerView.backgroundColor = vm.poolBackgroundColor
            self.qrCodeContainerView.backgroundColor = vm.qrCodeBackgroundColor
            self.poolContainerView.alpha = vm.poolAlpha
            self.qrCodeContainerView.alpha = vm.qrCodeAlpha
        }
    }
    
    // MARK: - Actions
    @IBAction func workTapped(_ sender: Any) {
        Session.shared.isUserWorking = !Session.shared.isUserWorking
        setupUI()
    }
    
    @IBAction func poolTapped(_ sender: Any) {
        delegate?.poolTapped()
    }
    
    @IBAction func qrCodeTapped(_ sender: Any) {
        delegate?.qrCodeTapped()
    }
    
    // MARK: - Notifications
    @objc private func userStateChanged() {
        setupUI()
    }
}
