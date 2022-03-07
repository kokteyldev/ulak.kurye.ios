//
//  BaseVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit

class BaseVC: UIViewController {
    private var loadingView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func disableView() {
        self.view.isUserInteractionEnabled = false
    }
    
    func enabledView() {
        self.view.isUserInteractionEnabled = true
    }
    
    // MARK: - Loading
    func showLoading(message: String? = nil, isFullscreen: Bool = false, isDark: Bool = true) {
        var frame = self.view.bounds
        
        if isFullscreen, let rootVC = UIApplication.rootWindow?.rootViewController {
            frame = rootVC.view.bounds
        }
        
        loadingView = LoadingView(message: message, frame: frame, isDark: isDark)
        
        if isFullscreen {
            loadingView?.show(from: UIApplication.rootWindow?.rootViewController ?? self)
        } else {
            loadingView?.show(from: self)
        }
    }
    
    func hideLoading() {
        loadingView?.close()
    }
}
