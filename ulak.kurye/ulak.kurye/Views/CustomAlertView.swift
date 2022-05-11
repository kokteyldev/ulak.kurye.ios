//
//  CustomAlertView.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 6.04.2022.
//

import UIKit

class CustomAlertView: BaseVC {

    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // MARK: - Init
    static func policyVC(_ orderTVC: OrderTVC, order: Order) -> CustomAlertView {
        let vc = CustomAlertView(nibName: "CustomAlertView", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        
        return vc
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func acceptTapped(_ sender: Any) {
    }
}
