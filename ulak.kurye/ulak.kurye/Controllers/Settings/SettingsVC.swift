//
//  SettingsVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit
import SafariServices

final class SettingsVC: BaseTBLVC {
    @IBOutlet weak var termOfUseCell: UITableViewCell!
    @IBOutlet weak var ulakCardCell: UITableViewCell!
    @IBOutlet weak var feedbackCell: UITableViewCell!
    @IBOutlet weak var rateCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    @IBOutlet weak var cardNumberLabel: UILabel!
    
    @IBOutlet weak var reminderCell: UITableViewCell!
    @IBOutlet weak var poolReminderCell: UITableViewCell!
    @IBOutlet weak var notificationCell: UITableViewCell!
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var poolNotificationSwitch: UISwitch!
    @IBOutlet weak var appNotificationSwitch: UISwitch!
    
    @IBOutlet weak var notificationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var poolNotificationActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var appNotificationActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.title = "settings_title".localized
        
        let cardNumber = Session.shared.user?.cardNumber
        if cardNumber == nil {
            cardNumberLabel.text = "settings_no_ulak_card".localized
        } else {
            cardNumberLabel.text = cardNumber
        }
        
        notificationSwitch.isOn = Session.shared.user?.isNotificationAllowed ?? true
        poolNotificationSwitch.isOn = Session.shared.user?.isPoolNotificationAllowed ?? true
        
        NotificationManager.shared.isNotificationPermissionRequired { isRequired in
            DispatchQueue.main.async {
                self.reminderCell.isHidden = isRequired
                self.poolReminderCell.isHidden = isRequired
                self.notificationCell.isHidden = !isRequired
                self.appNotificationSwitch.isOn = !isRequired
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Data
    private func updateUlakCardNumber() {
        prepareForLoading()
        
        let qrInputVC = QRInputCodeVC.qrInputVC(title: "settings_ulak_card_popup_title".localized,
                                                inputTitle: "settings_ulak_card_popup_input_title".localized,
                                                qrCodeKey: nil)
        self.present(qrInputVC, animated: true, completion: nil)
        
        qrInputVC.dismissCallback = { code in
            self.resetAfterLoading()
            
            guard let code = code else { return }
            self.showLoading(message: "card_loading".localized, isFullscreen: true, isDark: true)
            
            API.updateCardNumber(cardNumber: code) { result in
                switch result {
                case Result.success(_):
                    Session.shared.user?.cardNumber = code
                    self.hideLoading()
                    self.setupUI()
                    break
                case Result.failure(let error):
                    self.hideLoading()
                    self.view.showToast(.error, message: error.localizedDescription)
                    break
                }
            }
        }
        
        qrInputVC.cancelCallback = {
            self.enabledView()
            self.hideLoading()
            return
        }
    }
    
    private func updateUserSettings() {
        API.updateUserSettings(isNotificationAllowed: self.notificationSwitch.isOn, isPoolNotificationAllowed: self.poolNotificationSwitch.isOn) { result in
            self.resetAfterLoading()
            
            switch result {
            case Result.success(_):
                Session.shared.user?.isNotificationAllowed = self.notificationSwitch.isOn
                Session.shared.user?.isPoolNotificationAllowed = self.poolNotificationSwitch.isOn
                self.setupUI()
                break
            case Result.failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
                self.notificationSwitch.isOn = Session.shared.user?.isNotificationAllowed ?? true
                self.poolNotificationSwitch.isOn = Session.shared.user?.isPoolNotificationAllowed ?? true
                break
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func notificationSwitchTapped(_ sender: Any) {
        prepareForLoading()
        notificationSwitch.isHidden = true
        notificationActivityIndicator.startAnimating()
        updateUserSettings()
    }
    
    @IBAction func poolNotificationSwitchTapped(_ sender: Any) {
        prepareForLoading()
        poolNotificationSwitch.isHidden = true
        poolNotificationActivityIndicator.startAnimating()
        updateUserSettings()
    }
    
    @IBAction func appNotificationSwitchTapped(_ sender: Any) {
        NotificationManager.shared.shouldAskNotificationPermission { shouldAsk in
            if shouldAsk {
                NotificationManager.shared.getNotificationConsent()
            } else {
                NotificationManager.shared.openAppNotificationSettings()
            }
        }
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title: String?
        
        if section == 0 {
            title = "settings_account_settings".localized
        } else if section == 1 {
            title = "settings_notification_settings".localized
        } else if section == 2 {
            title = "settings_app_settings".localized
        }
        
        if let title = title {
            let headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
            headerView.titleLabel.text = title
            headerView.titleLabel.textAlignment = .left
            return headerView
        }
    
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if cell.isHidden {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        if cell.isEqual(feedbackCell) {
            FeedBackVC.present(fromVC: self)
        } else if cell.isEqual(ulakCardCell) {
            if Session.shared.user?.cardNumber == nil {
                updateUlakCardNumber()
            }
        } else if cell.isEqual(termOfUseCell) {
            self.showSafari(for: Session.shared.config.kvvkURL?.url)
        } else if cell.isEqual(rateCell) {
            guard let url = URL(string: Constants.App.appURL) else { return }
            UIApplication.shared.open(url)
        } else if cell.isEqual(logoutCell) {
            let alert = UIAlertController(title: "settings_logout_alert_title".localized, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "settings_logout".localized, style: .destructive, handler: { action in
                Session.shared.logout()
                PreLoginVC.presentAsRoot()
            }))
            alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { action in }))
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - Notifications
    @objc private func didBecomeActive() {
        setupUI()
    }
}

// MARK: - Utils
extension SettingsVC {
    private func showSafari(for urlString: String?) {
        if let urlString = urlString,
           let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            self.present(vc, animated: true, completion: nil)
        } else {
            self.view.showToast(.error, message: "error_unknown".localized)
        }
    }
}

extension SettingsVC: NetworkRequestable {
    func prepareForLoading() {
        disableView()
    }
    
    func resetAfterLoading() {
        enabledView()
        notificationActivityIndicator.stopAnimating()
        poolNotificationActivityIndicator.stopAnimating()
        appNotificationActivityIndicator.stopAnimating()
        notificationSwitch.isHidden = false
        poolNotificationSwitch.isHidden = false
        appNotificationSwitch.isHidden = false
    }
}
