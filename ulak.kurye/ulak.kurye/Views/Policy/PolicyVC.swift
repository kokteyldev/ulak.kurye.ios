//
//  PolicyVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit
import WebKit

protocol PolicyVCDelegate: AnyObject {
    func policyVCDidAccept(policyVC: PolicyVC)
}

final class PolicyVC: BaseVC {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var acceptButton: UIButton!
    
    weak var delegate: PolicyVCDelegate?
    var popupTitle: String?
    var popupURL: String?
    var isButtonHidden: Bool?
    
    // MARK: - Init
    static func policyVC(urlModel: ServerURL) -> PolicyVC {
        let vc = PolicyVC(nibName: "PolicyVC", bundle: nil)
        vc.popupTitle = urlModel.title
        vc.popupURL = urlModel.url
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    func setupUI() {
        guard let url = URL(string: popupURL ?? "") else { return }
        webView.load(URLRequest(url:url))
        titleLabel.text = popupTitle
        acceptButton.titleLabel?.numberOfLines = 1
        acceptButton.titleLabel?.adjustsFontSizeToFitWidth = true
        acceptButton.titleLabel?.lineBreakMode = .byWordWrapping
        acceptButton.isHidden = isButtonHidden ?? false
    }
    
    // MARK: - Actions
    @IBAction func acceptTapped(_ sender: Any) {
        delegate?.policyVCDidAccept(policyVC: self)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
