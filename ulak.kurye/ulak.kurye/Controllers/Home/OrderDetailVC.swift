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
    
    @IBOutlet weak var breakpointTableView: UITableView!
    @IBOutlet weak var breakpointHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var packageContentTitleContainer: UIView!
    @IBOutlet weak var packageContentContainer: UIView!

    @IBOutlet weak var courierNoteTitleContainer: UIView!
    @IBOutlet weak var courierNoteContainer: UIView!
    
    @IBOutlet weak var breakpointsTitleContainer: UIView!
    @IBOutlet weak var breakpointsContainer: UIView!
    
    var order: Order?
    private var viewModel: OrderDetailVM?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupMap()
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
    
    private func setupMap() {
        mapView.settings.consumesGesturesInView = false
        mapView.camera = GMSCameraPosition.camera(withLatitude: LocationManager.shared.location.latitude, longitude: LocationManager.shared.location.longitude, zoom: 13.0)
    }
    
    func setupUI() {
        //TODO: show no order alert and go back if order is nil
        guard let order = order else { return }
        
        viewModel = OrderDetailVM(order: order)
        guard let viewModel = viewModel else { return }
        
        self.title = viewModel.pageTitle
        orderCodeLabel.text = viewModel.orderCode
        serviceInfoLabel.text = viewModel.serviceTitle
        
        pickDateLabel.text = viewModel.pickAddressDetail
        pickAddressLabel.text = viewModel.pickAddress
        senderNameLabel.text = viewModel.senderName
        
        deliverDateLabel.text = viewModel.deliverAddressDetail
        deliverAddressLabel.text = viewModel.deliverAddress
        receiverNameLabel.text = viewModel.receiverName
        
        packageContentLabel.text = viewModel.packageDetail
        courierNoteLabel.text = viewModel.courierNote
        
        if viewModel.isPackageDetailHidden == true {
            stackView.removeFully(view: packageContentTitleContainer)
            stackView.removeFully(view: packageContentContainer)
        }
        
        if viewModel.isCourierNoteHidden == true {
            stackView.removeFully(view: courierNoteTitleContainer)
            stackView.removeFully(view: courierNoteContainer)
        }
        
        if viewModel.isBreakpointsHidden == true {
            stackView.removeFully(view: breakpointsTitleContainer)
            stackView.removeFully(view: breakpointsContainer)
        }
        
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
        breakpointTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func mapTapped(_ sender: Any) {
        guard let viewModel = viewModel else { return }

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
