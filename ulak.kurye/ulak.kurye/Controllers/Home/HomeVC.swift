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
    
    private var isNetworkRequestInProgress = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Aktif sipariş varken çalışmıyoruma tıklarsa uyarı göster
        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged), name: .UserStateChanged, object: nil)
        tableView.registerCell(type: OrderTVC.self)
        
        setupHeaderView()
        setupNoDataView()
        getOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
    
    // MARK: - Data
    func getOrders() {
        let group = DispatchGroup()
        var errorMessages = [String]()
        
        prepareForLoading()
        
        group.enter()
        API.getOrders(status: OrderStatus.running.rawValue) { result in
            switch result {
            case Result.success(let orderResponse):
                self.orderDataSource.addNewOrders(orderResponse.orders)
                self.tableView.reloadData()
                group.leave()
                break
            case Result.failure(let error):
                errorMessages.append(error.localizedDescription)
                group.leave()
                break
            }
        }
        
        group.enter()
        API.getOrders(status: OrderStatus.closed.rawValue) { result in
            switch result {
            case Result.success(let orderResponse):
                self.orderDataSource.addNewPastOrders(orderResponse)
                self.tableView.reloadData()
                group.leave()
                break
            case Result.failure(let error):
                errorMessages.append(error.localizedDescription)
                group.leave()
                break
            }
        }
        
        group.notify(queue: .main) {
            self.resetAfterLoading()
            self.tableView.reloadData()
            
            if errorMessages.count > 0 {
                self.view.showToast(.error, message: errorMessages.joined(separator: "\n"))
                return
            }
        }
    }
    
    func getMoreOrders() {
        if isNetworkRequestInProgress { return }
        if !orderDataSource.shouldRequestMorePast { return }
        isNetworkRequestInProgress = true
        
        DispatchQueue.main.async {
            self.tableView.tableFooterView = self.tableView.footerLoadingView()
        }
        
        API.getOrders(status: OrderStatus.closed.rawValue) { result in
            DispatchQueue.main.async {
                self.tableView.tableFooterView = nil
            }
            
            switch result {
            case Result.success(let orderResponse):
                self.isNetworkRequestInProgress = false
                
                let indexPaths = (self.orderDataSource.pastOrderVMs.count..<(self.orderDataSource.pastOrderVMs.count + orderResponse.orders.count)).map { IndexPath(row: $0, section: 1) }
                self.orderDataSource.addNewPastOrders(orderResponse)
                
                if indexPaths.count != 0 {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                    self.tableView.endUpdates()
                }
                break
            case Result.failure(let error):
                self.isNetworkRequestInProgress = false
                self.view.showToast(.error, message: error.localizedDescription)
                break
            }
        }
    }
    
    // MARK: - Notifications
    @objc private func userStateChanged() {
        setupNoDataView()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetailVC" {
            guard let orderVM = sender as? OrderVM else { return }
            let orderDetailVC = segue.destination as! OrderDetailVC
            orderDetailVC.order = orderVM.order
        }
    }
}

// MARK: UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orderDataSource.order(indexPath: indexPath)
        performSegue(withIdentifier: "OrderDetailVC", sender: order)
    }
}

// MARK: UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = orderDataSource.isDataAvailable ? nil : noDataView
        return orderDataSource.tableView(numberOfRowsInSection: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == orderDataSource.pastOrderVMs.count - 1 {
            getMoreOrders()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTVC", for: indexPath) as! OrderTVC
        
        let order = orderDataSource.order(indexPath: indexPath)
        cell.setOrder(order)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
            headerView.titleLabel.text = "home_active_orders".localized
            return headerView
        }
        
        let headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
        headerView.titleLabel.text = "home_past_orders".localized
        return headerView
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

extension HomeVC: NetworkRequestable {
    func prepareForLoading() {
        self.showLoading(isDark: false)
        
        self.headerView.isHidden = true
        self.tableView.isHidden = true
    }
    
    func resetAfterLoading() {
        self.hideLoading()
        
        self.headerView.isHidden = false
        self.tableView.isHidden = false
    }
}
