//
//  HomeVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 23.02.2022.
//

import UIKit

final class HomeVC: BaseVC {
    @IBOutlet weak var tableView: UITableView!
    
    private var orders: [Any] = ["1", "2", "3", "4"]
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
        let userState = Session.shared.userState
        
        DispatchQueue.main.async {
            self.noDataView = nil
            
            if userState != .working || self.orders.count == 0 {
                
                self.noDataView = NoDataView(userState: userState)
                self.tableView.reloadData()
            } else {
                self.tableView.reloadData()
            }
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
        tableView.backgroundView = orders.count == 0 ? noDataView : nil
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
}

// MARK: UIScrollViewDelegate
extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        if  offset >= 30 {
            
            let startLoadingThreshold: Double = 130
            let fractionDragged: Double = Double(offset-30) / startLoadingThreshold
            
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

