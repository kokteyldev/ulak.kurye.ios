//
//  ProfileVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit

final class ProfileVC: BaseVC {
    @IBOutlet weak var saveButton: KKLoadingButton!
    @IBOutlet weak var nameTextField: KKOutlinedTextField!
    @IBOutlet weak var surnameTextField: KKOutlinedTextField!
    @IBOutlet weak var phoneCodeView: PhoneCodeView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private var activeTextField : UITextField?
    private var feedBackGenerator: UINotificationFeedbackGenerator?
    private var phoneNumber: String!
    private var isFirstLogin: Bool = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupProfile()
        hideKeyboardWhenTappedAround()
        
        nameTextField.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Setup
    func setupUI() {
        if isFirstLogin {
            let screenSize: CGRect = UIScreen.main.bounds
            let screenSizeHeight: CGFloat = screenSize.height
            self.topConstraint.constant = screenSizeHeight / 5
            self.saveButton.setTitle("done".localized, for: .normal)
        } else {
            self.title = "profile_title".localized
            self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
            self.saveButton.setTitle("profile_change_password_save".localized, for: .normal)
        }
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        phoneCodeView.disableView()
        
        feedBackGenerator = UINotificationFeedbackGenerator()
        feedBackGenerator?.prepare()
    }
    
    private func setupProfile() {
        if isFirstLogin {
            if let phone = self.phoneNumber {
                phoneCodeView.setFullPhoneNumber(phone)
            }
        } else {
            nameTextField.text = Session.shared.user?.name
            surnameTextField.text = Session.shared.user?.surname
            
            if let phone = Session.shared.user?.phoneNumber {
                phoneCodeView.setFullPhoneNumber(phone)
            }
        }
    }
    
    // MARK: - Data
    private func validateData() {
        if nameTextField.text == nil || nameTextField.text?.isValidName == false {
            saveButton.isActive = false
            return
        }
        
        if surnameTextField.text == nil || surnameTextField.text?.isValidSurname == false {
            saveButton.isActive = false
            return
        }
        
        if !isFirstLogin {
            if nameTextField.text == Session.shared.user?.name &&
                surnameTextField.text == Session.shared.user?.surname {
                saveButton.isActive = false
                return
            }
        }
        
        saveButton.isActive = true
    }
    
    // MARK: - Actions
    @IBAction func saveTapped(_ sender: Any) {
        view.endEditing(true)
        
        var hasError = false
        
        let name = nameTextField.text
        if name == nil || name?.isValidName == false {
            nameTextField.invalidate()
            hasError = true
        }
        
        let surname = surnameTextField.text
        if surname == nil || surname?.isValidSurname == false {
            surnameTextField.invalidate()
            hasError = true
        }
        
        if hasError {
            feedBackGenerator?.notificationOccurred(.error)
            self.navigationController?.view.showToast(.error, message: "profile_mising_info".localized)
            return
        }
        
        prepareForLoading()
        
        API.updateProfile(name: name, surname: surname) { result in
            self.resetAfterLoading()
            
            switch result {
            case .success(_):
                if self.isFirstLogin {
                    Session.shared.user?.name = name
                    Session.shared.user?.surname = surname
                    self.saveButton.isActive = false
                    SplashVC.checkProfile()
                } else {
                    self.view.showToast(.success, message: "profile_updated_success".localized)
                    Session.shared.user?.name = name
                    Session.shared.user?.surname = surname
                    self.saveButton.isActive = false
                }
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
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
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
    
    // MARK: - Presenter
    static func present(fromVC: UIViewController, phoneNumber: String, isFirstLogin: Bool) {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            vc.phoneNumber = phoneNumber
            vc.isFirstLogin = isFirstLogin

            fromVC.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate
extension ProfileVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        
        guard let textfield = textField as? KKOutlinedTextField else { return }
        textfield.validate()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension ProfileVC: NetworkRequestable {
    func prepareForLoading() {
        saveButton.startAnimation()
        self.disableView()
    }
    
    func resetAfterLoading() {
        saveButton.stopAnimation()
        self.enabledView()
    }
}

