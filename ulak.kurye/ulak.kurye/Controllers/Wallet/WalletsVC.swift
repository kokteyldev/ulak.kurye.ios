//
//  WalletsVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import UIKit
import KokteylUtils

final class WalletsVC: BaseVC {
    @IBOutlet weak var walletSegment: UISegmentedControl!
    @IBOutlet weak var segmentHeightCons: NSLayoutConstraint!
    @IBOutlet weak var segmentTopCons: NSLayoutConstraint!
    @IBOutlet weak var transferContainerView: KKUIView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var balanceContainerView: KKUIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var userWallets: [BaseWallet] = []
    private var walletVM: WalletVM?
    private lazy var noDataView: NoDataView = {
        let title = userWallets.count == 0 ? "wallet_no_wallet".localized : "wallet_no_transaction".localized
        let view = NoDataView(title: title,
                              message: "",
                              image: .init(named: "ic-wallet")!)
        view.frame = tableView.bounds
        return view
    }()
    
    private var selectedSegmentIndex: Int {
        if walletSegment.selectedSegmentIndex >= 0 {
            return walletSegment.selectedSegmentIndex
        }
        
        return 0
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getWallets()
        setupUI()

        tableView.registerCell(type: WalletTVC.self)
        setupSegmentedControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWalletDetail()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - Setup
    private func setupUI() {
        self.title = "wallet_title".localized
        
        let attr = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 14)!
        ]
        
        let selectedAttr = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 14)!
        ]
        
        walletSegment.setTitleTextAttributes(attr, for: .normal)
        walletSegment.setTitleTextAttributes(selectedAttr, for: .selected)
    }
    
    private func setupSegmentedControl() {
        walletSegment.removeAllSegments()
        
        if userWallets.count == 0 {
            segmentTopCons.constant = 0
            segmentHeightCons.constant = 0
            walletSegment.isHidden = true
            balanceContainerView.alpha = transferContainerView.alpha
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
            return
        } else {
            segmentTopCons.constant = 8
            segmentHeightCons.constant = 40
            walletSegment.isHidden = false
            balanceContainerView.alpha = transferContainerView.alpha
        }
        
        if userWallets.count == 1 {
            self.title = userWallets[0].name
            segmentTopCons.constant = 0
            segmentHeightCons.constant = 0
            walletSegment.isHidden = true
        }
        
        var index = 0
        for wallet in userWallets {
            walletSegment.insertSegment(withTitle: wallet.name, at: index, animated: false)
            index += 1
        }
        
        walletSegment.selectedSegmentIndex = 0
    }
    
    private func setupData() {
        let title = userWallets.count == 0 ? "wallet_no_wallet".localized : "wallet_no_transaction".localized
        noDataView.titleLabel.text = title
        
        balanceLabel.text = walletVM?.balance ?? "0"
        transferContainerView.alpha = walletVM?.transferButtonAlpha ?? 0.5
        balanceContainerView.alpha = walletVM?.transferButtonAlpha ?? 0.5
        tableView.reloadData()
    }
    
    // MARK: - Data
    func getWallets() {
        API.getWallets { result in
            self.resetAfterLoading()
            
            switch result {
            case .success(let response):
                if let walletsResponse = response {
                    self.userWallets = walletsResponse
                }
                self.setupSegmentedControl()
                self.setupData()
                break
            case .failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
                break
            }
        }
    }
    
    func getWalletDetail() {
        if userWallets.count == 0 { return }
        let userWallet = userWallets[walletSegment.selectedSegmentIndex]
        
        prepareForLoading()
        walletVM = nil
        
        API.getWallet(walletUUID: userWallet.uuid) { result in
            self.resetAfterLoading()
            
            switch result {
            case Result.success(let walletResponse):
                if let walletResponse = walletResponse {
                    self.walletVM = WalletVM(walletResponse: walletResponse)
                }
                self.setupData()
                break
            case Result.failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
                break
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func transferBalanceTapped(_ sender: Any) {
        guard let walletVM = walletVM else { return }
        if walletVM.payableBalance == 0 { return }
        
        let button = sender as? KKLoadingButton
        button?.startAnimation()
        disableView()
        
        let alert = UIAlertController(title: "\(walletVM.balance) " + "wallet_transfer_balance_message".localized, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { action in
            API.transferBalance(walletUUID: walletVM.uuid, amount: walletVM.payableBalance) { result in
                button?.stopAnimation()
                self.enabledView()
                
                switch result {
                case Result.success(_):
                    self.getWalletDetail()
                    break
                case Result.failure(let error):
                    self.view.showToast(.error, message: error.localizedDescription)
                    break
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: { action in
            self.enabledView()
            button?.stopAnimation()
        }))
        self.present(alert, animated: true)
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        getWalletDetail()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OrderDetailVC" {
            guard let orderUUID = sender as? String else { return }
            let orderDetailVC = segue.destination as! OrderDetailVC
            orderDetailVC.orderUUID = orderUUID
        }
    }
}

// MARK: UITableViewDelegate
extension WalletsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let orderUUID = walletVM?.transactions[indexPath.row].orderUUID {
            performSegue(withIdentifier: "OrderDetailVC", sender: orderUUID)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: UITableViewDataSource
extension WalletsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = walletVM?.transactions.count ?? 0 > 0 ? nil : noDataView
        return walletVM?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTVC", for: indexPath) as! WalletTVC
        
        if let transaction = walletVM?.transactions[indexPath.row] {
            cell.setTransaction(transaction)
        }
        
        return cell
    }
}

extension WalletsVC: NetworkRequestable {
    func prepareForLoading() {
        self.disableView()
        tableView.isHidden = true
        balanceContainerView.isHidden = true
        transferContainerView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func resetAfterLoading() {
        self.enabledView()
        tableView.isHidden = false
        balanceContainerView.isHidden = false
        transferContainerView.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
