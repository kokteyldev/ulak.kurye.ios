//
//  PhoneCodeTVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit

//TODO: bu dosyanın xib'i olsun.
final class PhoneCodeTVC: UITableViewCell {
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneCodeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Data
    func setCountry(_ country: Country) {
        self.flagLabel.text = country.flag
        self.nameLabel.text = country.countryName
        self.phoneCodeLabel.text = country.phoneCode
    }
}
