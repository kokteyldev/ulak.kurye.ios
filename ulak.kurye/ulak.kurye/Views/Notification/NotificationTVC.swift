//
//  NotificationTVC.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 1.04.2022.
//

import UIKit

final class NotificationTVC: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Data
    func setNotification(_ notificationModel: SystemNotification) {
        self.titleLabel.text = notificationModel.data.body.title
        self.detailLabel.text = notificationModel.data.body.body
        self.dateLabel.text = notificationModel.createdAt.serverDate?.shortDateString
    }
}
