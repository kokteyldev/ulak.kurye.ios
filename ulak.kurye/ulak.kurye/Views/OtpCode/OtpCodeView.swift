//
//  OtpCodeView.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 19.04.2022.
//

import UIKit

protocol OtpCodeViewDelegate: AnyObject {
    func didChangeOtpCode(_ otpCodeView: OtpCodeView)
}

final class OtpCodeView: UIView {
    @IBOutlet var otpCodeView: UIView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    
    private var textField: UITextField?
    
    var passcode: String?
    weak var delegate: OtpCodeViewDelegate?
    
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
        loadAndAttachView()
        setupUI()
    }
    
    // MARK: - Setup
    func setupUI() {
        textField = UITextField()
        textField?.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        textField?.isHidden = true
        textField?.delegate = self
        textField?.keyboardType = .numberPad
        textField?.textContentType = .oneTimeCode

        addSubview(textField!)
        textField?.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: Any) {
        textField?.becomeFirstResponder()
    }
    
    @objc func textDidChange(textfield: UITextField) {
        let text = textfield.text
        let tempSubstring = text?.suffix(4)
        let tempPasscode = "\(tempSubstring ?? "")"
        
        firstLabel.text = tempPasscode.character(atIndex: 0)
        secondLabel.text = tempPasscode.character(atIndex: 1)
        thirdLabel.text = tempPasscode.character(atIndex: 2)
        fourthLabel.text = tempPasscode.character(atIndex: 3)
    
        validateData()
    }
    
    func validateData() {
        passcode = nil
        firstLabel.validate()
        secondLabel.validate()
        thirdLabel.validate()
        fourthLabel.validate()
        
        if textField?.text?.length != 4 { return }
        passcode = textField?.text
        
        delegate?.didChangeOtpCode(self)
    }
    
    func invalidate() {
        firstLabel.invalidate()
        secondLabel.invalidate()
        thirdLabel.invalidate()
        fourthLabel.invalidate()
        
        textField?.becomeFirstResponder()
    }
}

extension OtpCodeView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 4
    }
}
