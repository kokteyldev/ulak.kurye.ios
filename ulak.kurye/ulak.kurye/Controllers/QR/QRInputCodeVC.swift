//
//  QRInputCodeVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 17.03.2022.
//

import UIKit

final class QRInputCodeVC: BaseVC {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeTextfield: KKOutlinedTextField!
    @IBOutlet weak var sendButton: UIButton!
    
    var popupTitle: String?
    var inputTitle: String?
    var qrCodeKey: String?
    
    var dismissCallback: ((String?) -> Void)?
    
    // MARK: - Init
    static func qrInputVC(title: String, inputTitle: String, qrCodeKey: String?) -> QRInputCodeVC {
        let vc = QRInputCodeVC(nibName: "QRInputCodeVC", bundle: nil)
        vc.popupTitle = title
        vc.inputTitle = inputTitle
        vc.qrCodeKey = qrCodeKey
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(gestureTapped))
        self.view.addGestureRecognizer(tapgesture)
    }
    
    // MARK: - Setup
    private func setupUI() {
        titleLabel.text = popupTitle
        codeTextfield.title = inputTitle
    }

    // MARK: - Actions
    @IBAction func qrTapped(_ sender: Any) {
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        closeVC()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.codeTextfield.text = nil
        closeVC()
    }
    
    @objc func gestureTapped() {
        self.codeTextfield.text = nil
        closeVC()
    }
    
    // MARK: Util
    private func closeVC() {
        self.dismiss(animated: true) {
            if let dismissCallback = self.dismissCallback {
                dismissCallback(self.codeTextfield.text?.length == 0 ? nil : self.codeTextfield.text)
            }
        }
    }
}
