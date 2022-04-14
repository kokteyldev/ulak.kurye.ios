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
    var cancelCallback: (() -> Void)?
    
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
        let svc = ScannerVC()
        svc.delegate = self
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true, completion: nil)
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        closeVC()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        cancelVC()
    }
    
    @objc func gestureTapped() {
        cancelVC()
    }
    
    // MARK: Util
    private func closeVC() {
        self.dismiss(animated: true) {
            if let dismissCallback = self.dismissCallback {
                dismissCallback(self.codeTextfield.text?.length == 0 ? nil : self.codeTextfield.text)
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

//TODO: Error mesajını düzelt.
extension QRInputCodeVC: ScannerDelegate {
    func didScanCode(code: String) {
        if qrCodeKey == nil {
            codeTextfield.text = code
            return
        }
        
        // picking_security_code: DutHix, orderCode: b-1545171599
        let data = code.data(using: .utf8)!
        do {
            guard let parameters = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> else {
                self.view.showToast(.error, message: "scan_error".localized)
                return
            }
            
            if let foundedResult = parameters[qrCodeKey!] {
                codeTextfield.text = "\(foundedResult)"
            } else {
                self.view.showToast(.error, message: "scan_error".localized)
                return
            }
            
        } catch let error as NSError {
            self.view.showToast(.error, message: error.localizedDescription)
            return
        }
    }
    
    func didFailScan(errorMessage: String) {
        self.view.showToast(.error, message: errorMessage)
    }
}
