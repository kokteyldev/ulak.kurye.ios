//
//  SplashVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit
import OneSignal

final class SplashVC: BaseVC {
    @IBOutlet weak var loadingView: UIView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView.rotate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        API.config { result in
            switch result {
            case .success(let config):
                Session.shared.start(config)
                self.checkForceUpdate(config)
            case .failure(let error):
                self.view.showToast(.error, message: error.localizedDescription, autoHide: false)
            }
        }
    }
    
    // MARK: - Util
    private func checkForceUpdate(_ config: Config) {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {

            let compareResult = appVersion.versionCompare(config.latestVersion)

            if compareResult != .orderedAscending {
                checkAuth()
                return
            }
        }

        let alertController = UIAlertController(title: nil, message: "force_update_message".localized, preferredStyle: .alert)

        let action = UIAlertAction(title: "force_update_button_title".localized, style: .default) { _ in
            if let url = URL(string: Constants.App.appURL) {
                UIApplication.shared.open(url)
            }
        }

        alertController.addAction(action)

        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    private func checkAuth() {
        if Session.shared.isUserLoggedIn {
            SplashVC.checkProfile()
        } else {
            if Session.shared.isOnboardingSeen {
                PreLoginVC.presentAsRoot()
            } else {
                OnboardingVC.presentAsRoot()
            }
        }
    }

    static func checkProfile() {
        API.me { result in
            switch result {
            case .success(let user):
                Session.shared.user = user
                LocationManager.shared.start()
                MainTabbarTC.presentAsRoot()
                
                OneSignal.setExternalUserId("\(user.id)", withSuccess: { results in
                    Log.d("Onesignal id updated: \(results!.description)")
                }, withFailure: {error in
                    Log.e("Set external user id done with error: " + error.debugDescription)
                })
            case .failure(_):
                Session.shared.logout()
                PreLoginVC.presentAsRoot()
            }
        }
    }

}
