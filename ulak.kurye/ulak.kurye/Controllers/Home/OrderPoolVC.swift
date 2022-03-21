//
//  OrderPoolVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 12.03.2022.
//

import UIKit

final class OrderPoolVC: BaseTBLVC {
    private var orderVMs: [OrderVM] = []
    private var headerView: TableSectionHeaderView?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupHeaderView()
        getOrders()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UserStateChanged, object: nil)
    }
    
    // MARK: - Setup
    func setupUI() {
        self.title = "pool_page_title".localized
        NotificationCenter.default.addObserver(self, selector: #selector(userStateChanged), name: .UserStateChanged, object: nil)
        tableView.registerCell(type: OrderTVC.self)
    }
    
    func setupHeaderView() {
        headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
        headerView?.titleLabel.text = "pool_total_order".localized + " - \(OrderManager.shared.activeOrderCount) / \(Session.shared.maxOrderCount)"
    }
    
    // MARK: - Data
    func getOrders() {
        prepareForLoading()
        
        API.getPoolOrders(latitude: LocationManager.shared.location.latitude, longtitude: LocationManager.shared.location.longitude) { result in
            switch result {
            case Result.success(let orders):
                for order in orders {
                    self.orderVMs.append(OrderVM(order: order))
                }
                
                self.resetAfterLoading()
                self.tableView.reloadData()
                break
            case Result.failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
                self.resetAfterLoading()
                break
            }
        }
    }
    
    // MARK: - Data - Order
    func getOrderFromPool(_ orderTVC: OrderTVC, order: Order) {
        prepareForLoading()
        
        let group = DispatchGroup()
        var agreement: Agreement?
        
        group.enter()
        API.getOrderAgreements(orderUUID: order.uuid) { result in
            switch result {
            case Result.success(let agreementResponse):
                agreement = agreementResponse.aggrements.first
                group.leave()
                break
            case Result.failure(let error):
                self.resetAfterLoading()
                orderTVC.stopLoading()
                self.view.showToast(.error, message: error.localizedDescription)
                break
            }
        }
        
        group.notify(queue: .main) {
            guard let agreement = agreement else {
                self.resetAfterLoading()
                orderTVC.stopLoading()
                self.view.showToast(.error, message: CustomError.noAgreement.error.localizedDescription)
                return
            }
            
            API.runTakeAction(orderUUID: order.uuid, agreementUUID: agreement.uuid) { result in
                switch result {
                case Result.success(_):
                    self.resetAfterLoading()
                    OrderManager.shared.didTakeAction(order: order)
                    self.setupHeaderView()
                    self.tableView.reloadData()
                    
                    if let index = self.orderVMs.firstIndex(where: { $0.order.uuid == order.uuid }) {
                        self.orderVMs.remove(at: index)
                        
                        let indexPath = IndexPath(row: index, section: 0)
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                    break
                case Result.failure(let error):
                    self.resetAfterLoading()
                    orderTVC.stopLoading()
                    self.view.showToast(.error, message: error.localizedDescription)
                    break
                }
            }
        }
    }

    // MARK: - UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO: noDataview ekle
        return orderVMs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTVC", for: indexPath) as! OrderTVC
        cell.setOrder(orderVMs[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerView != nil ? 32.0 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let order = orderVMs[indexPath.row].order
        performSegue(withIdentifier: "OrderDetailVC", sender: order)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetailVC" {
            guard let order = sender as? Order else { return }
            let orderDetailVC = segue.destination as! OrderDetailVC
            orderDetailVC.order = order
        }
    }
    
    // MARK: - Notifications
    @objc private func userStateChanged() {
        //TODO: check status and hide orders if needed.
    }
}

// MARK: - OrderTVCDelegate
extension OrderPoolVC: OrderTVCDelegate {
    func orderTVCAddTapped(_ orderTVC: OrderTVC, order: Order) {
        //TODO: tasarımdaki gibi bi alert yap.
        let alert = UIAlertController(title: "pool_task_take_alert_title".localized, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
            self.getOrderFromPool(orderTVC, order: order)
        }))
        alert.addAction(UIAlertAction(title: "cancel".localized, style: .cancel, handler: { action in
            orderTVC.stopLoading()
        }))
        self.present(alert, animated: true)
        
    }
}

// MARK: - NetworkRequestable
extension OrderPoolVC: NetworkRequestable {
    func prepareForLoading() {
        self.showLoading(isDark: false)
    }
    
    func resetAfterLoading() {
        self.hideLoading()
    }
}
