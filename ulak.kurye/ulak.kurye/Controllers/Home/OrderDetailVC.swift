//
//  OrderDetailVC.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 7.03.2022.
//

import UIKit
import GoogleMaps

class OrderDetailVC: BaseVC {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var mapView: GMSMapView!
    
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
    
    @IBOutlet weak var pickNameContainerView: UIView!
    @IBOutlet weak var deliverNameContainerView: UIView!
    @IBOutlet weak var ownerTitleContainerView: UIView!
    @IBOutlet weak var ownerAddressContainerView: UIView!
    
    @IBOutlet weak var pickMapButton: UIButton!
    @IBOutlet weak var deliverMapButton: UIButton!
    
    @IBOutlet weak var pickCallButton: UIButton!
    @IBOutlet weak var deliverCallButton: UIButton!
    
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerCallButton: UIButton!
    
    @IBOutlet weak var breakpointTableView: UITableView!
    @IBOutlet weak var breakpointHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var packagePriceTitleContainer: UIView!
    @IBOutlet weak var packagePriceContainer: UIView!
    
    @IBOutlet weak var packagePriceTitleLabel: UILabel!
    @IBOutlet weak var packagePaymentMethodTitleLabel: UILabel!
    @IBOutlet weak var packagePrepareTimeTitleLabel: UILabel!
    @IBOutlet weak var packagePriceLabel: UILabel!
    @IBOutlet weak var packagePaymentMethodLabel: UILabel!
    @IBOutlet weak var packagePrepareTimeLabel: UILabel!
    
    @IBOutlet weak var packageContentTitleContainer: UIView!
    @IBOutlet weak var packageContentContainer: UIView!

    @IBOutlet weak var courierNoteTitleContainer: UIView!
    @IBOutlet weak var courierNoteContainer: UIView!
    
    @IBOutlet weak var breakpointsTitleContainer: UIView!
    @IBOutlet weak var breakpointsContainer: UIView!
    
    @IBOutlet weak var actionsView: OrderActionsView!
    @IBOutlet weak var actionsViewHeightCons: NSLayoutConstraint!
    var order: Order?
    var orderUUID: String?
    
    private var viewModel: OrderDetailVM?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "order_detail_title".localized
        
        setupTableView()
        setupMap()
        
        setupUI()
        getActions()
        
        if orderUUID != nil {
            getOrder(orderUUID!)
        }
    }
    
    // MARK: - Data
    func getActions() {
        if order == nil || order!.status == .closed {
            actionsView.isHidden = true
            actionsViewHeightCons.constant = 0
            return
        }
        
        actionsView.prepareForLoading()
        actionsView.delegate = self
        actionsView.setOrderUUID(order!.uuid)
    }
    
    func getOrder(_ orderUUID: String) {
        prepareForLoading()
        API.getOrder(orderUUID: orderUUID) { result in
            self.resetAfterLoading()
            
            switch result {
            case Result.success(let order):
                self.order = order
                self.setupUI()
                OrderManager.shared.updateOrder(order: order)
                break
            case Result.failure(let error):
                //TODO: hata göster ve geri git
                print(error.localizedDescription)
                break
            }
        }
    }
    
    // MARK: - Setup
    func setupTableView() {
        breakpointTableView.registerCell(type: BreakpointTVC.self)
        breakpointTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    private func setupMap() {
        mapView.settings.consumesGesturesInView = false
        mapView.camera = GMSCameraPosition.camera(withLatitude: LocationManager.shared.location.latitude, longitude: LocationManager.shared.location.longitude, zoom: 13.0)
    }
    
    func setupUI() {
        //TODO: show no order alert and go back if order is nil
        guard let order = order else { return }
        
        viewModel = OrderDetailVM(order: order)
        guard let viewModel = viewModel else { return }
        
        orderCodeLabel.text = viewModel.orderCode
        serviceInfoLabel.text = viewModel.serviceTitle
        
        pickDateLabel.text = viewModel.pickAddressDetail
        pickAddressLabel.text = viewModel.pickAddress
        senderNameLabel.text = viewModel.senderName
        
        deliverDateLabel.text = viewModel.deliverAddressDetail
        deliverAddressLabel.text = viewModel.deliverAddress
        receiverNameLabel.text = viewModel.receiverName
        
        ownerNameLabel.text = viewModel.ownerName
        
        packagePriceLabel.text = viewModel.packagePrice
        packagePrepareTimeLabel.text = viewModel.packagePrepareTime
        packagePaymentMethodLabel.text = viewModel.packagePaymentMethod
        
        packageContentLabel.text = viewModel.packageDetail
        courierNoteLabel.text = viewModel.courierNote
        
        pickMapButton.isUserInteractionEnabled = viewModel.isMapButtonsActive
        deliverMapButton.isUserInteractionEnabled = viewModel.isMapButtonsActive
        pickMapButton.alpha = viewModel.mapButtonsAlpha
        deliverMapButton.alpha = viewModel.mapButtonsAlpha
        
        pickCallButton.isUserInteractionEnabled = viewModel.isMapButtonsActive
        deliverCallButton.isUserInteractionEnabled = viewModel.isMapButtonsActive
        ownerCallButton.isUserInteractionEnabled = viewModel.isMapButtonsActive
        pickCallButton.alpha = viewModel.mapButtonsAlpha
        deliverCallButton.alpha = viewModel.mapButtonsAlpha
        ownerCallButton.alpha = viewModel.mapButtonsAlpha
        
        pickNameContainerView.isHidden = viewModel.isDetailsHidden
        deliverNameContainerView.isHidden = viewModel.isDetailsHidden
        ownerTitleContainerView.isHidden = viewModel.isDetailsHidden
        ownerAddressContainerView.isHidden = viewModel.isDetailsHidden
        
        packagePriceTitleContainer.isHidden = viewModel.isPackagePriceHidden
        packagePriceContainer.isHidden = viewModel.isPackagePriceHidden
        
        packageContentTitleContainer.isHidden = viewModel.isPackageDetailHidden
        packageContentContainer.isHidden = viewModel.isPackageDetailHidden
        
        courierNoteTitleContainer.isHidden = viewModel.isCourierNoteHidden
        courierNoteContainer.isHidden = viewModel.isCourierNoteHidden

        breakpointsTitleContainer.isHidden = viewModel.isBreakpointsHidden
        breakpointsContainer.isHidden = viewModel.isBreakpointsHidden
        
        actionsViewHeightCons.constant = viewModel.isActionViewHeight
            
        if !viewModel.isDetailsHidden {
            var bounds = GMSCoordinateBounds()
            
            let senderMarker = GMSMarker(position: viewModel.senderLocation)
            senderMarker.icon = .init(named: "ic-marker-orange")
            senderMarker.map = mapView
            bounds = bounds.includingCoordinate(viewModel.senderLocation)

            let receiverMarker = GMSMarker(position: viewModel.receiverLocation)
            receiverMarker.icon = .init(named: "ic-marker-blue")
            receiverMarker.map = mapView
            bounds = bounds.includingCoordinate(viewModel.receiverLocation)
            
            mapView.animate(with: GMSCameraUpdate.fit(bounds, with: .init(top: 38, left: 20, bottom: 2, right: 20)))
        }
        
        breakpointTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func mapTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        if viewModel.isDetailsHidden { return }

        if viewModel.isPackagePicked {
            getMapDirections(viewModel.receiverLocation)
        } else {
            getMapDirections(viewModel.senderLocation)
        }
    }
    
    @IBAction func senderLocationTapped(_ sender: Any) {
        guard let sender = viewModel?.senderLocation else { return }
        getMapDirections(sender)
    }
    
    @IBAction func callSenderTapped(_ sender: Any) {
        //TODO: Endpoint bekleniyor.
    }
    
    @IBAction func receiverLocationTapped(_ sender: Any) {
        guard let receiver = viewModel?.receiverLocation else { return }
        getMapDirections(receiver)
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
    
    // MARK: - Utils
    private func getMapDirections(_ location: CLLocationCoordinate2D) {
        let url = URL(string: "comgooglemaps://?saddr=&daddr=\(location.latitude),\(location.longitude)&directionsmode=driving")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!)
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

extension OrderDetailVC: OrderActionsViewDelegate {
    func didRunAction(_ action: OrderAction, error: Error?) {
        if let error = error {
            self.view.showToast(.error, message: error.localizedDescription)
            return
        }

        self.getOrder(order!.uuid)
    }
}

extension OrderDetailVC: NetworkRequestable {
    func prepareForLoading() {
        self.showLoading(isDark: false)
        self.stackView.isHidden = true
    }
    
    func resetAfterLoading() {
        self.hideLoading()
        self.stackView.isHidden = false
    }
}
