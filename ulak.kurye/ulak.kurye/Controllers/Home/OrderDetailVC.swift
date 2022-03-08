//
//  OrderDetailVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 7.03.2022.
//

import UIKit

class OrderDetailVC: BaseVC {
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var serviceInfoLabel: UILabel!
    @IBOutlet weak var pickDateLabel: UILabel!
    @IBOutlet weak var pickAddressLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var deliverDateLabel: UILabel!
    @IBOutlet weak var deliverAddressLabel: UILabel!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var packageContentLabel: UILabel!
    @IBOutlet weak var courierNoteLabel: UILabel!
    
    @IBOutlet weak var breakpointTableView: UITableView!
    @IBOutlet weak var breakpointHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var packageContentTitleContainer: UIView!
    @IBOutlet weak var packageContentContainer: UIView!

    @IBOutlet weak var courierNoteTitleContainer: UIView!
    @IBOutlet weak var courierNoteContainer: UIView!
    
    @IBOutlet weak var breakpointsTitleContainer: UIView!
    @IBOutlet weak var breakpointsContainer: UIView!
    
    var order: Order?
    var viewModel: OrderDetailVM?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupUI()
    }
    
    deinit {
        breakpointTableView.removeObserver(self, forKeyPath: "contentSize", context: nil)
    }
    
    // MARK: - Setup
    func setupTableView() {
        breakpointTableView.registerCell(type: BreakpointTVC.self)
        breakpointTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    func setupUI() {
        //TODO: show no order alert and go back if order is nil
        guard let order = order else { return }
        viewModel = OrderDetailVM(order: order)
        
        self.title = viewModel?.pageTitle
        orderCodeLabel.text = viewModel?.orderCode
        serviceInfoLabel.text = viewModel?.serviceTitle
        
        pickDateLabel.text = viewModel?.pickAddressDetail
        pickAddressLabel.text = viewModel?.pickAddress
        senderNameLabel.text = viewModel?.senderName
        
        deliverDateLabel.text = viewModel?.deliverAddressDetail
        deliverAddressLabel.text = viewModel?.deliverAddress
        receiverNameLabel.text = viewModel?.receiverName
        
        packageContentLabel.text = viewModel?.packageDetail
        courierNoteLabel.text = viewModel?.courierNote
        
        if viewModel?.isPackageDetailHidden == true {
            stackView.removeFully(view: packageContentTitleContainer)
            stackView.removeFully(view: packageContentContainer)
        }
        
        if viewModel?.isCourierNoteHidden == true {
            stackView.removeFully(view: courierNoteTitleContainer)
            stackView.removeFully(view: courierNoteContainer)
        }
        
        if viewModel?.isBreakpointsHidden == true {
            stackView.removeFully(view: breakpointsTitleContainer)
            stackView.removeFully(view: breakpointsContainer)
        }
        
        breakpointTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func senderLocationTapped(_ sender: Any) {
    }
    
    @IBAction func callSenderTapped(_ sender: Any) {
        //TODO: Endpoint bekleniyor.
    }
    
    @IBAction func receiverLocationTapped(_ sender: Any) {
    }
    
    @IBAction func callReceiverTapped(_ sender: Any) {
        //TODO: Endpoint bekleniyor.
    }
    
    // MARK: - Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize") {
            breakpointHeightConst?.constant = breakpointTableView.contentSize.height
        }
    }
}

// MARK: - UITableView
extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.breakpoints.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BreakpointTVC", for: indexPath) as! BreakpointTVC
        
        if let breakpoint = viewModel?.breakpoints[indexPath.row] {
            cell.setBreakpoint(breakpoint)
        }
        
        return cell
    }
}
