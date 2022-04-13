//
//  WalletTVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit

final class WalletTVC: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Data
    func setTransaction(_ transactionVM: WalletTransactionVM) {
        self.amountLabel.text = transactionVM.amount
        self.typeLabel.text = transactionVM.type
        self.dateLabel.text = transactionVM.date
    }
}
