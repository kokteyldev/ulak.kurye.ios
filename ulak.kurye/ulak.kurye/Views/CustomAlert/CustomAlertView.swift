//
//  CustomAlertView.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 6.04.2022.
//

import UIKit

final class CustomAlertView: BaseVC {
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    
    var acceptCallback: (() -> Void)?
    var cancelCallback: (() -> Void)?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 5
        
    }
    // MARK: - Init
    static func customAlertView() -> CustomAlertView {
        let vc = CustomAlertView(nibName: "CustomAlertView", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
    
    // MARK: - Actions
    @IBAction func cancelTapped(_ sender: Any) {
        cancelVC()
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
        acceptTapped()
    }
    
    private func acceptTapped() {
        self.dismiss(animated: true) {
            if let acceptCallback = self.acceptCallback {
                acceptCallback()
            }
        }
    }
    
    private func cancelVC() {
        self.dismiss(animated: true) {
            if let cancelCallback = self.cancelCallback {
                cancelCallback()
            }
        }
    }
}
