//
//  LoginVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

final class LoginVC: BaseVC {
    @IBOutlet weak var logoTopConst: NSLayoutConstraint!
    @IBOutlet weak var titleLabelTopConst: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: KKLoadingButton!
    @IBOutlet weak var otpCodeView: OtpCodeView!

    private var feedBackGenerator: UINotificationFeedbackGenerator?

    var phoneNumber: String?
    var isRegistered: Bool = true
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUI()
        hideKeyboardWhenTappedAround()
        validateData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        validateData()
    }
    
    // MARK: - UI
    private func setupUI() {
        navigationController?.setNavigationBarTransparent(true)
        feedBackGenerator = UINotificationFeedbackGenerator()
        feedBackGenerator?.prepare()
        
        otpCodeView?.delegate = self
    }
    
    // MARK: - Data
    private func validateData() {
        let code = otpCodeView.passcode
        if code == nil || code?.length != 4 {
            loginButton.isActive = false
            return
        }

        loginButton.isActive = true
    }
    
    // MARK: - Action
    @IBAction func loginTapped(_ sender: Any) {
        view.endEditing(true)
        
        var hasError = false
        
        let code = otpCodeView.passcode
        if code == nil || code?.length != 4 {
            otpCodeView.invalidate()
            hasError = true
        }
        
        if phoneNumber == nil || phoneNumber?.isValidPhoneNumber == false {
            otpCodeView.invalidate()
            hasError = true
        }
        
        if hasError {
            feedBackGenerator?.notificationOccurred(.error)
            self.navigationController?.view.showToast(.error, message: "login_mising_info".localized)
            return
        }
        
        loginButton.startAnimation()
        self.disableView()
        
        API.login(code: code!, phoneNumber: phoneNumber!) { result in
            self.enabledView()
            self.loginButton.stopAnimation()
            
            switch result {
            case .success(let loginResponse):
                Session.shared.token = loginResponse.tokenString
                if self.isRegistered {
                    ProfileVC.present(fromVC: self, phoneNumber: self.phoneNumber!, isFirstLogin: true)
                } else if loginResponse.user != nil {
                    Session.shared.user = loginResponse.user
                    MainTabbarTC.presentAsRoot()
                } else {
                    SplashVC.checkProfile()
                }
                break
            case .failure(let error):
                self.otpCodeView.invalidate()
                self.navigationController?.view.showToast(.error, message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func textfieldDidChange(_ sender: Any) {
        validateData()
    }
    
    //MARK: - Utils
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return }
        let animateDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] ?? 0.25) as! Double
        
        let bottomOfTextField = loginButton.convert(loginButton.bounds, to: self.view).maxY;
        let topOfKeyboard = self.view.frame.height - keyboardSize.height
        
        if bottomOfTextField > topOfKeyboard {
            self.logoTopConst.constant = -8
            self.titleLabelTopConst.constant = 8.0
            UIView .animate(withDuration: animateDuration) {
                self.titleLabel.text = ""
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let animateDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] ?? 0.25) as! Double
        self.logoTopConst.constant = 16
        self.titleLabelTopConst.constant = 32.0
        UIView .animate(withDuration: animateDuration) {
            self.titleLabel.text = "login_title".localized
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - TextField Delegate
extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let textfield = textField as? KKOutlinedTextField {
            textfield.validate()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension LoginVC: OtpCodeViewDelegate {
    func didChangeOtpCode(_ otpCodeView: OtpCodeView) {
        validateData()
    }
}
