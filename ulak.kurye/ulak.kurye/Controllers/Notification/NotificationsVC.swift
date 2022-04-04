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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var notifications: [SystemNotification] = []
    private var paginate: Paginate = Paginate()
    
    private lazy var noDataView: UIView = {
        let view = NoDataView(title: "notifications_no_notification".localized,
                              message: "",
                              image: .init(named: "ic-notification")!)
        view.frame = tableView.bounds
        return view
    }()
    
    private var isNetworkRequestInProgress = false
    private var selectedType: Int {
        return segmentedControl.selectedSegmentIndex + 1
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getNotifications()
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
        tableView.registerCell(type: NotificationTVC.self)
        
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
    
    // MARK: - Data
    func getNotifications() {
        prepareForLoading()
        self.notifications = []
        self.paginate = Paginate()
        self.tableView.reloadData()
        
        API.getNotifications(page: 1, notification_type: selectedType) { result in
            self.resetAfterLoading()
            self.isNetworkRequestInProgress = false
            
            switch result {
            case Result.success(let notificationsResponse):
                if let notifications = notificationsResponse.notifications {
                    self.notifications = notifications
                }
                self.tableView.reloadData()
                break
            case Result.failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
                self.tableView.reloadData()
                break
            }
        }
    }
    
    private func getMoreAddress() {
        if isNetworkRequestInProgress { return }
        isNetworkRequestInProgress = true
        
        if paginate.page >= paginate.pagesTotal { return }
        
        DispatchQueue.main.async {
            self.tableView.tableFooterView = self.tableView.footerLoadingView()
        }
        
        API.getNotifications(page: paginate.page+1, notification_type: selectedType) { result in
            self.resetAfterLoading()
            self.isNetworkRequestInProgress = false
            
            switch result {
            case Result.success(let notificationsResponse):
                if let paginate = notificationsResponse.paginate, let newNotifications = notificationsResponse.notifications {
                    self.paginate = paginate
                    
                    let indexPaths = (self.notifications.count..<(self.notifications.count + newNotifications.count)).map { IndexPath(row: $0, section: 0) }
                    self.notifications.append(contentsOf: newNotifications)
                    
                    if indexPaths.count != 0 {
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: indexPaths, with: .automatic)
                        self.tableView.endUpdates()
                    }
                }
                break
            case Result.failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
                self.tableView.reloadData()
                break
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func segmentChanged(_ sender: Any) {
        getNotifications()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == notifications.count - 1 {
            getMoreAddress()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTVC", for: indexPath) as! NotificationTVC
        cell.setNotification(notifications[indexPath.row])
        return cell
    }
}

extension NotificationsVC: NetworkRequestable {
    func prepareForLoading() {
        segmentedControl.isUserInteractionEnabled = false
        disableView()
        tableView.isHidden = true
        activityIndicator.startAnimating()
    }
    
    func resetAfterLoading() {
        segmentedControl.isUserInteractionEnabled = true
        enabledView()
        tableView.isHidden = false
        activityIndicator.stopAnimating()
        
        DispatchQueue.main.async {
            self.tableView.tableFooterView = nil
        }
    }
}
