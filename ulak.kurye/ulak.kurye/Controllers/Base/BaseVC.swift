//
//  BaseVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.02.2022.
//

import UIKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func disableView() {
        self.view.isUserInteractionEnabled = false
    }
    
    func enabledView() {
        self.view.isUserInteractionEnabled = true
    }
}
