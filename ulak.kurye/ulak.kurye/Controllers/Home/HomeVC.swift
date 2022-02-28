//
//  HomeVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 23.02.2022.
//

import UIKit

final class HomeVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    
    private var orderDataSource = OrderDataSource()
    private var noDataView: NoDataView?
    
    private var headerView = HomeHeaderView()
    private let headerAnimation = CABasicAnimation(keyPath: "opacity")
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged), name: .UserStateChanged, object: nil)
        
        setupHeaderView()
        setupNoDataView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UserStateChanged, object: nil)
    }
    
    // MARK: - Setup
    func setupHeaderView() {
        tableView.setAndLayoutTableHeaderView(header: headerView)
        
        headerAnimation.toValue = 0.0
        headerAnimation.fromValue = 1.0
        headerAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        headerView.layer.add(headerAnimation, forKey: "fade")
        headerView.layer.speed = 0
        headerView.layer.timeOffset = 0
    }
    
    func setupNoDataView() {
        DispatchQueue.main.async {
            self.noDataView = NoDataView(userState: Session.shared.userState)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Notifications
    @objc private func userStateChanged() {
        setupNoDataView()
    }
}

// MARK: UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

// MARK: UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = orderDataSource.activeOrders.count > 0 ? nil : noDataView
        return orderDataSource.activeOrders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if orderDataSource.activeOrders.count > 0 {
            let headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
            headerView.titleLabel.text = "home_active_orders".localized
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32.0
    }
}

// MARK: UIScrollViewDelegate
extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        if offset >= 10 {
            let startLoadingThreshold: Double = 130
            let fractionDragged: Double = Double(offset-10) / startLoadingThreshold
            
            self.headerView.layer.timeOffset = Double.minimum(1.0, fractionDragged)
            
            if UIApplication.shared.statusBarStyle != preferredStatusBarStyle {
                self.setNeedsStatusBarAppearanceUpdate()
            }
            
        } else {
            self.headerView.layer.timeOffset = 0
            
            if UIApplication.shared.statusBarStyle != preferredStatusBarStyle {
                self.setNeedsStatusBarAppearanceUpdate()
            }
        }
    }
}

