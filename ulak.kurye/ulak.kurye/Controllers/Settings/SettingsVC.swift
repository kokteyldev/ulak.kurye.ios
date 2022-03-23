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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
    }
    
    // MARK: - Data
    private func updateUlakCardNumber() {
        let qrInputVC = QRInputCodeVC.qrInputVC(title: "settings_ulak_card_popup_title".localized,
                                                inputTitle: "settings_ulak_card_popup_input_title".localized,
                                                qrCodeKey: nil)
        self.present(qrInputVC, animated: true, completion: nil)
        
        qrInputVC.dismissCallback = { code in
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
    }
    
    // MARK: - UITableViewDelegate
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