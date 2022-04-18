//
//  LoginVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.02.2022.
//

import UIKit

class LoginVC: BaseVC {
    @IBOutlet weak var loginButton: KKLoadingButton!
    
    @IBOutlet weak var otpFirst: KKOutlinedTextField!
    @IBOutlet weak var otpSecond: KKOutlinedTextField!
    @IBOutlet weak var otpThird: KKOutlinedTextField!
    @IBOutlet weak var otpFourth: KKOutlinedTextField!
    
    
    private var feedBackGenerator: UINotificationFeedbackGenerator?
    private var activeTextField : UITextField?
    
    var phoneNumber: String?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        otpFirst.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        otpSecond.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        otpThird.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        otpFourth.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        
        setupUI()
        validateData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        otpFirst.becomeFirstResponder()
        validateData()
    }
    
    // MARK: - UI
    private func setupUI() {
        navigationController?.setNavigationBarTransparent(true)
        feedBackGenerator = UINotificationFeedbackGenerator()
        feedBackGenerator?.prepare()
    }
    
    // MARK: - Data
    private func validateData() {
        let codeOne = otpFirst.text
        let codeTwo = otpSecond.text
        let codeThree = otpThird.text
        let codeFour = otpFourth.text
        
        let code = codeOne! + codeTwo! + codeThree! + codeFour!
        if code.length != 4 {
            loginButton.isActive = false
            return
        }

        loginButton.isActive = true
    }
    
    // MARK: - Action
    @IBAction func loginTapped(_ sender: Any) {
        view.endEditing(true)
        
        var hasError = false
        
        let codeOne = otpFirst.text
        if codeOne == nil || codeOne?.length != 1 {
            otpFirst.invalidate()
            hasError = true
        }
        
        let codeTwo = otpSecond.text
        if codeTwo == nil || codeTwo?.length != 1 {
            otpSecond.invalidate()
            hasError = true
        }
        
        let codeThree = otpThird.text
        if codeThree == nil || codeThree?.length != 1 {
            otpThird.invalidate()
            hasError = true
        }
        
        let codeFour = otpFourth.text
        if codeFour == nil || codeFour?.length != 1 {
            otpFourth.invalidate()
            hasError = true
        }
        
        let code = codeOne! + codeTwo! + codeThree! + codeFour!
        if code.length != 4 {
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
        
        API.login(code: code, phoneNumber: phoneNumber!) { result in
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
    
    @objc func textDidChange(textfield: UITextField) {
        let text = textfield.text
        
        if text?.utf16.count == 1 {
            switch textfield {
            case otpFirst:
                otpSecond.becomeFirstResponder()
                break
            case otpSecond:
                otpThird.becomeFirstResponder()
                break
            case otpThird:
                otpFourth.becomeFirstResponder()
                break
            case otpFourth:
                otpFourth.resignFirstResponder()
                break
            default:
                break
            }
        }
        
        if text?.utf16.count == 0 {
            switch textfield {
            case otpFirst:
                otpFirst.becomeFirstResponder()
                break
            case otpSecond:
                otpFirst.becomeFirstResponder()
                break
            case otpThird:
                otpSecond.becomeFirstResponder()
                break
            case otpFourth:
                otpThird.becomeFirstResponder()
                break
            default:
                break
            }
        }
    }
}
