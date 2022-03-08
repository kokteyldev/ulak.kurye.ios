//
//  BreakpointTVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 8.03.2022.
//

import UIKit

final class BreakpointTVC: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    // MARK: - Data
    func setBreakpoint(_ breakpoint: OrderBreakpoint) {
        self.titleLabel.text = breakpoint.name
        self.dateLabel.text = breakpoint.date.serverDate?.shortDateString
    }
}
