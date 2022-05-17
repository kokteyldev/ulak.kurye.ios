//
//  PhoneCodeView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit

protocol PhoneCodeViewDelegate: AnyObject {
    func didChangePhoneCode(_ phoneCodeView: PhoneCodeView)
}

final class PhoneCodeView: UIView {
    @IBOutlet var phoneCodeView: UIView!
    @IBOutlet weak var phoneCodeButton: UIButton!
    @IBOutlet weak var phoneTextField: KKOutlinedTextField!
    
    private var country: Country?
    private var phoneNumber: String?
    weak var delegate: PhoneCodeViewDelegate?
    
    var validatedPhoneNumber: String? {
        var fullPhoneNumber = country?.phoneCode
        
        if phoneTextField.text != nil {
            fullPhoneNumber! += phoneTextField.text!
        } else {
            return nil
        }
        
        return fullPhoneNumber!
    }
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PhoneCodeView", owner: self, options: nil)
        addSubview(phoneCodeView)
        phoneCodeView.frame = self.bounds
        phoneCodeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        country = PhoneHelper.defaultCountry()
        setupPhoneNumber()
        phoneTextField.becomeFirstResponder()
        addDoneButtonOnNumpad(textField: phoneTextField)
    }
    
    // MARK: - Setup
    private func setupPhoneNumber() {
        phoneCodeButton.setTitle(country?.title, for: .normal)
        phoneTextField.text = phoneNumber
        phoneTextField.validate()
        delegate?.didChangePhoneCode(self)
    }
    
    func setFullPhoneNumber(_ fullPhoneNumber: String) {
        let (countryCode, phoneNumber) = PhoneHelper.parseFullPhoneNumber(fullPhoneNumber)
        self.country = PhoneHelper.countryForCountryCode(countryCode)
        self.phoneNumber = phoneNumber
        setupPhoneNumber()
    }
    
    // MARK: - Utils
    func invalidate() {
        phoneTextField.invalidate()
    }
    
    func disableView() {
        phoneCodeButton.backgroundColor = .init(named: "ulk-input-back")
        phoneCodeButton.isUserInteractionEnabled = false
        phoneCodeButton.alpha = 0.7
        phoneTextField.disableView()
    }
    
    func addDoneButtonOnNumpad(textField: UITextField) {
        let keypadToolbar: UIToolbar = UIToolbar()
        
        keypadToolbar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: textField, action: #selector(UITextField.resignFirstResponder))
        ]
        keypadToolbar.sizeToFit()
        textField.inputAccessoryView = keypadToolbar
    }

    // MARK: - Actions
    @IBAction func phoneCodeButtonTapped(_ sender: Any) {
        PhoneCodeVC.present(fromVC: UIApplication.topViewController()!, delegate: self)
    }
    
    @IBAction func textfieldDidChange(_ sender: Any) {
        let textfield = sender as? KKOutlinedTextField
        if let phoneNumberText = textfield?.text,
            let phoneNumber = PhoneHelper.phoneNumber(phoneNumberText) {
            textfield?.text = phoneNumber
        }
        
        delegate?.didChangePhoneCode(self)
    }
}

//MARK: - PhoneCodeVCDelegate
extension PhoneCodeView: PhoneCodeVCDelegate {
    func didSelectCountry(country: Country) {
        self.country = country
        setupPhoneNumber()
    }
}
