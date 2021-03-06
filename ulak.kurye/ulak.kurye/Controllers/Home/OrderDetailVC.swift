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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var serviceInfoLabel: UILabel!
    @IBOutlet weak var orderDistanceLabel: UILabel!
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
    
    @IBOutlet weak var checkpointTableView: UITableView!
    @IBOutlet weak var breakpointHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var restaurantTitleContainer: UIView!
    @IBOutlet weak var restaurantDetailContainer: UIView!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantIcon: UIImageView!
    
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
    
    @IBOutlet weak var checkpointsTitleContainer: UIView!
    @IBOutlet weak var checkpointsContainer: UIView!
    
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
    
    // MARK: - Setup
    func setupTableView() {
        checkpointTableView.registerCell(type: CheckpointTVC.self)
        checkpointTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    private func setupMap() {
        mapView.settings.consumesGesturesInView = false
        mapView.camera = GMSCameraPosition.camera(withLatitude: LocationManager.shared.location.latitude, longitude: LocationManager.shared.location.longitude, zoom: 13.0)
    }
    
    func setupUI() {
        guard let order = order else { return }
        
        viewModel = OrderDetailVM(order: order)
        guard let viewModel = viewModel else { return }
        
        orderCodeLabel.text = viewModel.orderCode
        serviceInfoLabel.text = viewModel.serviceTitle
        orderDistanceLabel.text = viewModel.estimatedDistance
        
        pickDateLabel.text = viewModel.pickAddressDetail
        pickAddressLabel.text = viewModel.pickAddress
        senderNameLabel.text = viewModel.senderName
        
        deliverDateLabel.text = viewModel.deliverAddressDetail
        deliverAddressLabel.text = viewModel.deliverAddress
        receiverNameLabel.text = viewModel.receiverName
        
        ownerNameLabel.text = viewModel.ownerName
        
        restaurantNameLabel.text = viewModel.order.customer?.brand
        restaurantIcon.image = viewModel.iconImage
        
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
        
        restaurantTitleContainer.isHidden = viewModel.isRestaurantDetailHidden
        restaurantDetailContainer.isHidden = viewModel.isRestaurantDetailHidden
        
        packagePriceTitleContainer.isHidden = viewModel.isPackagePriceHidden
        packagePriceContainer.isHidden = viewModel.isPackagePriceHidden
        
        packageContentTitleContainer.isHidden = viewModel.isPackageDetailHidden
        packageContentContainer.isHidden = viewModel.isPackageDetailHidden
        
        courierNoteTitleContainer.isHidden = viewModel.isCourierNoteHidden
        courierNoteContainer.isHidden = viewModel.isCourierNoteHidden

        checkpointsTitleContainer.isHidden = viewModel.isCheckpointsHidden
        checkpointsContainer.isHidden = viewModel.isCheckpointsHidden
        
        actionsViewHeightCons.constant = viewModel.isActionViewHeight
            
        if viewModel.isPastOrder {
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
        
        checkpointTableView.reloadData()
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
        actionsView.isHidden = false
    }
    
    func getOrder(_ orderUUID: String) {
        prepareForLoading()
        API.getOrder(orderUUID: orderUUID) { result in
            self.resetAfterLoading()
            
            switch result {
            case Result.success(let order):
                self.order = order
                self.setupUI()
                self.getActions()
                OrderManager.shared.updateOrder(order: order)
                break
            case Result.failure(let error):
                self.navigationController?.view.showToast(.error, message: error.localizedDescription)
                Log.e(error.localizedDescription)
                self.navigationController?.popToRootViewController(animated: true)
                break
            }
        }
    }
    
    func talkTo(sender: Any, to: String) {
        let button = sender as? KKLoadingButton
        button?.startAnimation(activityColor: .black)
        disableView()
        
        API.talkTo(orderUUID: order!.uuid, to: to) { result in
            button?.stopAnimation()
            self.enabledView()
            
            switch result {
            case Result.success(_):
                let phoneNumber = Session.shared.config.phoneNumber
                guard let url = URL(string: "telprompt://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) else {
                    self.view.showToast(.error, message: "error_unknown".localized)
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                break
            case Result.failure(let error):
                self.view.showToast(.error, message: error.localizedDescription)
                print(error.localizedDescription)
                break
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func mapTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        if !viewModel.isPastOrder { return }

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
        talkTo(sender: sender, to: "start_point")
    }
    
    @IBAction func callReceiverTapped(_ sender: Any) {
        talkTo(sender: sender, to: "end_point")
    }
    
    @IBAction func callOwnerTapped(_ sender: Any) {
        talkTo(sender: sender, to: "customer")
    }
    
    @IBAction func receiverLocationTapped(_ sender: Any) {
        guard let receiver = viewModel?.receiverLocation else { return }
        getMapDirections(receiver)
    }
    
    // MARK: - Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentSize") {
            breakpointHeightConst?.constant = checkpointTableView.contentSize.height
        }
    }
    
    // MARK: - Utils
    private func getMapDirections(_ location: CLLocationCoordinate2D) {
        let appleMapsUrl = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(location.latitude),\(location.longitude)")
        let googleMapsUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(location.latitude),\(location.longitude)&directionsmode=driving")
        if UIApplication.shared.canOpenURL(googleMapsUrl!) {
            UIApplication.shared.open(googleMapsUrl!)
        } else if UIApplication.shared.canOpenURL(appleMapsUrl!) {
            UIApplication.shared.open(appleMapsUrl!)
        }
    }
}

// MARK: - UITableView
extension OrderDetailVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.checkpoints.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckpointTVC", for: indexPath) as! CheckpointTVC
        
        if let breakpoint = viewModel?.checkpoints[indexPath.row] {
            cell.setCheckpoint(breakpoint)
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
        activityIndicator.startAnimating()
    }
    
    func resetAfterLoading() {
        self.hideLoading()
        self.stackView.isHidden = false
        activityIndicator.stopAnimating()
    }
}
