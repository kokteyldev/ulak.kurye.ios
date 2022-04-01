//
//  NotificationTVC.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 1.04.2022.
//

import UIKit

class NotificationTVC: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var notificationTimeLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setNotification(_ notificationModel: Notifications) {
        self.titleLabel.text = notificationModel.uuid
    }
}
