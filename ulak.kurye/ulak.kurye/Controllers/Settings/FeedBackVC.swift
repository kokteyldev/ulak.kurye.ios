//
//  FeedBackVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit

final class FeedBackVC: BaseVC {
    @IBOutlet weak var feedbackTextField: UITextView!
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Setup
    func setupUI() {
        //TODO: KKUITextField yapalım.
        feedbackTextField.delegate = self
        feedbackTextField.layer.borderWidth = 2
        feedbackTextField.layer.cornerRadius = 5
        feedbackTextField.layer.borderColor = UIColor(named: "ulk-input-border")?.cgColor
    }
    
    // MARK: Actions
    @IBAction func dismissTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        guard let feedback = feedbackTextField.text else { return }
        
        self.showLoading()
        
        API.sendFeedback(message: feedback) { result in
            self.hideLoading()
            switch result {
            case .success(_):
                self.view.showToast(.success, message: "settings_feedback_sent".localized)
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Presentation
    static func present(fromVC: UIViewController) {
        DispatchQueue.main.async {
            let sb = UIStoryboard(name: "Settings", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "FeedBackVC") as! FeedBackVC
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            fromVC.present(vc, animated: true, completion: nil)
        }
    }
}

extension FeedBackVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
