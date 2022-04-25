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
    @IBOutlet weak var otpFirst: KKOutlinedTextField!
    @IBOutlet weak var otpSecond: KKOutlinedTextField!
    @IBOutlet weak var otpThird: KKOutlinedTextField!
    @IBOutlet weak var otpFourth: KKOutlinedTextField!
        
    private var fullCode: String!
    weak var delegate: OtpCodeViewDelegate?

    var code: String? {
        return self.fullCode
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
        Bundle.main.loadNibNamed("OtpCodeView", owner: self, options: nil)
        addSubview(otpCodeView)
        otpCodeView.frame = self.bounds
        otpCodeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        otpFirst.becomeFirstResponder()
        
        setupUI()
    }
    
    func setupUI() {
        otpFirst.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        otpSecond.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        otpThird.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
        otpFourth.addTarget(self, action: #selector(self.textDidChange(textfield:)), for: UIControl.Event.editingChanged)
    }
    
    func validateData() {
        let codeOne = otpFirst.text
        let codeTwo = otpSecond.text
        let codeThree = otpThird.text
        let codeFour = otpFourth.text

        self.fullCode = codeOne! + codeTwo! + codeThree! + codeFour!

        delegate?.didChangeOtpCode(self)
    }
    
    func invalidate() {
        otpFirst.invalidate()
        otpSecond.invalidate()
        otpThird.invalidate()
        otpFourth.invalidate()
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
        validateData()
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
        return count <= 1
    }
}
