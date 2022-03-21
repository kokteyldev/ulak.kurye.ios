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
    @IBOutlet weak var feedbackCell: UITableViewCell!
    @IBOutlet weak var rateCell: UITableViewCell!
    @IBOutlet weak var logoutCell: UITableViewCell!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "settings_title".localized
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        if cell.isEqual(feedbackCell) {
            FeedBackVC.present(fromVC: self)
        } else if cell.isEqual(termOfUseCell) {
            self.showSafari(for: Session.shared.config.kvvkURL?.url)
        } else if cell.isEqual(rateCell) {
            guard let url = URL(string: Constants.App.appURL) else { return }
            UIApplication.shared.open(url)
        } else if cell.isEqual(logoutCell) {
            Session.shared.logout()
            PreLoginVC.presentAsRoot()
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
