//
//  NotificationsVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 22.03.2022.
//

import UIKit

final class NotificationsVC: BaseVC {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var notifications: [String] = []
    private lazy var noDataView: UIView = {
        let view = NoDataView(title: "notifications_no_notification".localized,
                              message: "",
                              image: .init(named: "ic-notification")!)
        view.frame = tableView.bounds
        return view
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupUI() {
        let attr = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 14)!
        ]
        
        let selectedAttr = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 14)!
        ]
        
        segmentedControl.setTitleTextAttributes(attr, for: .normal)
        segmentedControl.setTitleTextAttributes(selectedAttr, for: .selected)
        
        segmentedControl.removeAllSegments()
        segmentedControl.insertSegment(withTitle: "notifications".localized, at: 0, animated: false)
        segmentedControl.insertSegment(withTitle: "announcements".localized, at: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
    }

}

// MARK: UITableViewDataSource
extension NotificationsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = notifications.count > 0 ? nil : noDataView
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTVC", for: indexPath) as! OrderTVC
        return cell
    }
}
