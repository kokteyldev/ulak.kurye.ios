//
//  MainTabbarTC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

final class MainTabbarTC: UITabBarController {

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged), name: .UserStateChanged, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        setupIcons()
        setupTabItems()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UserStateChanged, object: nil)
    }
    
    // MARK: - Setup
    private func setupIcons() {
        DispatchQueue.main.async {
            self.tabBar.items?[0].image = UIImage(named: "tabbar-home")
            self.tabBar.items?[0].title = "tabbar_home".localized
            
            self.tabBar.items?[1].image = UIImage(named: "tabbar-notification")
            self.tabBar.items?[1].title = "tabbar_notification".localized
            
            self.tabBar.items?[2].image = UIImage(named: "tabbar-wallet")
            self.tabBar.items?[2].title = "tabbar_wallet".localized
            
            self.tabBar.items?[3].image = UIImage(named: "tabbar-settings")
            self.tabBar.items?[3].title = "tabbar_settings".localized
        }
    }
    
    private func setupTabItems() {
        DispatchQueue.main.async {
            self.tabBar.items?[1].isEnabled = Session.shared.isAccountVerified
            self.tabBar.items?[2].isEnabled = Session.shared.isAccountVerified
            self.tabBar.items?[3].isEnabled = Session.shared.isAccountVerified
        }
    }
    
    // MARK: - Notifications
    @objc private func userStateChanged() {
        self.viewWillLayoutSubviews()
    }
    
    // MARK: - Presentation
    static func presentAsRoot() {
        guard let window = UIApplication.rootWindow else { return }
        
        DispatchQueue.main.async {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                UIView.performWithoutAnimation({
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let rootController = storyboard.instantiateInitialViewController() as! MainTabbarTC
                    window.rootViewController = rootController
                })
            }, completion: nil)
        }
    }

}
