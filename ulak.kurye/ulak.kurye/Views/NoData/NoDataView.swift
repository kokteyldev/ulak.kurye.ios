//
//  NoDataView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 24.02.2022.
//

import UIKit

protocol NoDataViewDelegate: AnyObject {
    func goToPool()
}

final class NoDataView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var actionButton: KKLodingButton!
    
    weak var delegate: NoDataViewDelegate?
    private var userState: UserState?
    
    // MARK: - View Lifecycle
    convenience init(userState: UserState) {
        self.init()
        self.userState = userState
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
        setupUI()
    }
    
    // MARK: Setup
    func setupUI() {
        guard let userState = userState else { return }
        
        var image: UIImage?
        var message: String?
        var buttonTitle: String?
        
        switch userState {
        case .locationPermissionRequired:
            image = .init(named: "ic-location")
            message = "location_permission_message".localized
            buttonTitle = "give_location_permission".localized
        case .notificationPermissionRequired:
            image = .init(named: "ic-notification")
            message = "notification_permission_message".localized
            buttonTitle = "give_notification_permission".localized
        case .accountNotVerified:
            image = .init(named: "logo-orange")
            message = "waiting_for_account_verification".localized
            buttonTitle = "go_to_application_site".localized
        case .notWorking:
            buttonTitle = "start_work".localized
        case .working:
            message = "working_message".localized
            buttonTitle = "see_pool".localized
        }
        
        self.imageView.image = image
        self.messageLabel.text = message
        self.actionButton.setTitle(buttonTitle, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func actionTapped(_ sender: Any) {
        guard let userState = userState else { return }
        
        switch userState {
        case .locationPermissionRequired:
            LocationManager.shared.getLocationConsent()
        case .notificationPermissionRequired:
            NotificationManager.shared.getNotificationConsent()
        case .accountNotVerified:
            let url = URL(string: Constants.App.courierApplicationURL)!
            UIApplication.shared.open(url)
        case .notWorking:
            Session.shared.isUserWorking = true
        case .working:
            self.delegate?.goToPool()
        }
    }
}
