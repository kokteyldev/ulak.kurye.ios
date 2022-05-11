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
    private var activeOrderCount = 0
    private var refreshButton = UIButton()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView(title: "pool_no_order".localized,
                              message: "",
                              image: .init(named: "ic-restaurant")!)
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
        
        Session.shared.checkUserState()
        activeOrderCount = OrderManager.shared.activeOrderCount
        setupHeaderView()
        getOrders()
    }
    
    // MARK: - Setup
    func setupUI() {
        self.title = "pool_page_title".localized
        tableView.registerCell(type: OrderTVC.self)
        setupRefreshButton()
    }
    
    func setupHeaderView() {
        headerView = TableSectionHeaderView(frame: .init(x: 0, y: 0, width: tableView.frame.size.width, height: 32.0))
        headerView?.titleLabel.text = "pool_total_order".localized + " - \(activeOrderCount) / \(Session.shared.maxOrderCount)"
    }
    
    private func setupRefreshButton() {
        refreshButton.setImage(UIImage(named: "ic-refresh.png"), for: .normal)
        tableView.addSubview(refreshButton)
        
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.frame = CGRect(x: 307, y: 600 , width: 55, height: 55)
        refreshButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor, constant: -12).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        refreshButton.widthAnchor.constraint(equalToConstant: 55).isActive = true
        refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Data
    func getOrders() {
        prepareForLoading()
        
        API.getPoolOrders(latitude: LocationManager.shared.location.latitude, longtitude: LocationManager.shared.location.longitude) { result in
            switch result {
            case Result.success(let orders):
                self.orderVMs.removeAll()
                
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
        disableView()
        
        let group = DispatchGroup()
        var agreement: Agreement?
        
        group.enter()
        API.getOrderAgreements(orderUUID: order.uuid) { result in
            self.enabledView()
            
            switch result {
            case Result.success(let agreementResponse):
                agreement = agreementResponse.aggrements.first
                group.leave()
                break
            case Result.failure(let error):
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
                    orderTVC.stopLoading()
                    
                    self.resetAfterLoading()
                    OrderManager.shared.didTakeAction(order: order)
                    self.activeOrderCount += 1
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
        tableView.backgroundView = orderVMs.count > 0 ? nil : noDataView
        return orderVMs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTVC", for: indexPath) as! OrderTVC
        cell.setOrder(orderVMs[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return orderVMs.count > 0 ? headerView : nil
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
    
    @objc private func refreshButtonTapped() {
        getOrders()
    }
}

// MARK: - OrderTVCDelegate
extension OrderPoolVC: OrderTVCDelegate {
    func orderTVCAddTapped(_ orderTVC: OrderTVC, order: Order) {
        let customAlertView = CustomAlertView.customAlertView()
        
        customAlertView.acceptCallback = {
            self.getOrderFromPool(orderTVC, order: order)
        }
        
        customAlertView.cancelCallback = {
            orderTVC.stopLoading()
        }
        
        self.present(customAlertView, animated: true)
    }
}

// MARK: - NetworkRequestable
extension OrderPoolVC: NetworkRequestable {
    func prepareForLoading() {
        noDataView.isLoading = true
        self.tableView.backgroundView = noDataView
        self.showLoading(isDark: false)
        self.refreshButton.isHidden = true
    }
    
    func resetAfterLoading() {
        noDataView.isLoading = false
        self.tableView.backgroundView = nil
        self.hideLoading()
        self.refreshButton.isHidden = false
    }
}
