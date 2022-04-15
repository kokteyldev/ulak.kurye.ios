//
//  LoginVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

class LoginVC: BaseVC {
    @IBOutlet weak var codeTextField: KKOutlinedTextField!
    @IBOutlet weak var loginButton: KKLoadingButton!
    
    private var feedBackGenerator: UINotificationFeedbackGenerator?
    private var activeTextField : UITextField?
    
    var phoneNumber: String?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUI()
        validateData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UI
    private func setupUI() {
        navigationController?.setNavigationBarTransparent(true)
        
        codeTextField.delegate = self
        
        feedBackGenerator = UINotificationFeedbackGenerator()
        feedBackGenerator?.prepare()
    }
    
    // MARK: - Data
    private func validateData() {
        if codeTextField.text?.length != 4 {
            loginButton.isActive = false
            return
        }
        
        loginButton.isActive = true
    }
    
    // MARK: - Action
    @IBAction func loginTapped(_ sender: Any) {
        view.endEditing(true)
        
        var hasError = false
        
        let code = codeTextField.text
        if code == nil || code?.length != 4 {
            codeTextField.invalidate()
            hasError = true
        }
        
        if phoneNumber == nil || phoneNumber?.isValidPhoneNumber == false {
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
                
                if loginResponse.user != nil {
                    Session.shared.user = loginResponse.user
                    MainTabbarTC.presentAsRoot()
                } else {
                    SplashVC.checkProfile()
                }
                break
            case .failure(let error):
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
        
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                self.view.frame.origin.y = 0 - keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

// MARK: - TextField Delegate
extension LoginVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        if let textfield = textField as? KKOutlinedTextField {
            textfield.validate()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
