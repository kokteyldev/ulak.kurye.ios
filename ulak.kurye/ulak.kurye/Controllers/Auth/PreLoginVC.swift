//
//  PreLoginVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

final class PreLoginVC: BaseVC {
    @IBOutlet weak var phoneCodeView: PhoneCodeView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelTopConst: NSLayoutConstraint!
    @IBOutlet weak var logoTopConst: NSLayoutConstraint!
    @IBOutlet weak var kvvkPolicyButton: UIButton!
    @IBOutlet weak var loginButton: KKLoadingButton!
    
    private var feedBackGenerator: UINotificationFeedbackGenerator?
    private var termOfUseVC: PolicyVC?
    
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
    
    // MARK: - UI
    private func setupUI() {
        kvvkPolicyButton.underline()
        kvvkPolicyButton.titleLabel?.numberOfLines = 1
        kvvkPolicyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        kvvkPolicyButton.titleLabel?.lineBreakMode = .byWordWrapping
        
        navigationController?.setNavigationBarTransparent(true)
        
        phoneCodeView.delegate = self
        
        feedBackGenerator = UINotificationFeedbackGenerator()
        feedBackGenerator?.prepare()
    }
    
    // MARK: - Data
    private func validateData() {
        if phoneCodeView.validatedPhoneNumber?.isPhoneNumber == false {
            loginButton.isActive = false
            return
        }
        
        if kvvkPolicyButton.isSelected == false {
            loginButton.isActive = false
            return
        }
        
        loginButton.isActive = true
    }
    
    // MARK: - Action
    @IBAction func kvkkPolicyTapped(_ sender: Any) {
        view.endEditing(true)
        
        if !kvvkPolicyButton.isSelected {
            if let urlString = Session.shared.config.kvvkURL {
                termOfUseVC = PolicyVC.policyVC(urlModel: urlString)
                termOfUseVC?.delegate = self
                self.present(termOfUseVC!, animated: true) {}
            } else {
                self.view.showToast(.error, message: "error_unknown".localized)
            }
        } else {
            kvvkPolicyButton.isSelected = !kvvkPolicyButton.isSelected
            validateData()
        }
    }
    
    @IBAction func textfieldDidChange(_ sender: Any) {
        validateData()
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        view.endEditing(true)
        
        var hasError = false
        
        let phoneNumber = phoneCodeView.validatedPhoneNumber
        if phoneNumber == nil || phoneNumber?.isPhoneNumber == false {
            phoneCodeView.invalidate()
            hasError = true
        }
        
        if hasError {
            feedBackGenerator?.notificationOccurred(.error)
            self.navigationController?.view.showToast(.error, message: "preLogin_mising_info".localized)
            return
        }
        
        loginButton.startAnimation()
        self.disableView()
        
        API.preLogin(phoneNumber: phoneNumber!) { result in
            self.enabledView()
            self.loginButton.stopAnimation()
            
            switch result {
            case .success(let preLoginResponse):
                self.isRegistered = preLoginResponse.isRegistered
                self.performSegue(withIdentifier: "login", sender: phoneNumber)
                break
            case .failure(let error):
                self.navigationController?.view.showToast(.error, message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login" {
            guard let phoneNumber = sender as? String else { return }
            let loginVC = segue.destination as! LoginVC
            loginVC.phoneNumber = phoneNumber
            loginVC.isRegistered = self.isRegistered
        }
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
            self.titleLabel.text = "preLogin_title".localized
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Presentation
    static func presentAsRoot() {
        guard let window = UIApplication.rootWindow else { return }
        
        DispatchQueue.main.async {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                UIView.performWithoutAnimation({
                    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                    let rootController = storyboard.instantiateInitialViewController() as! UINavigationController
                    window.rootViewController = rootController
                })
            }, completion: nil)
        }
    }
}

// MARK: - TextField Delegate
extension PreLoginVC: UITextFieldDelegate {
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

// MARK: - PhoneCodeViewDelegate
extension PreLoginVC: PhoneCodeViewDelegate {
    func didChangePhoneCode(_ phoneCodeView: PhoneCodeView) {
        validateData()
    }
}

// MARK: - RegisterPolicyCheck
extension PreLoginVC: PolicyVCDelegate {
    func policyVCDidAccept(policyVC: PolicyVC) {
        self.kvvkPolicyButton.isSelected = true
        validateData()
    }
}
