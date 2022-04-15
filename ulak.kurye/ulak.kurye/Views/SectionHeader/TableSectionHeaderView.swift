//
//  TableSectionHeaderView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 28.02.2022.
//

import UIKit

final class TableSectionHeaderView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - View Lifecycle
    convenience init(title: String) {
        self.init()
        commonInit()
    }
    
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
    }
}
