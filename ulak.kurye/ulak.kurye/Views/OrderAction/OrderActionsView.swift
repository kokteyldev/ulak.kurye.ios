//
//  OrderActionsView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import UIKit
import CloudKit

protocol OrderActionsViewDelegate: AnyObject {
    func didRunAction(_ action: OrderAction, error: Error?)
}

final class OrderActionsView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    weak var delegate: OrderActionsViewDelegate?
    private var actions: [OrderAction] = []
    private var orderUUID: String?
    private var agreement: Agreement?
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        loadAndAttachView()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        collectionView.registerCell(OrderActionCVC.self)
        collectionView.contentInsetAdjustmentBehavior = .never
        
        resetAfterLoading()
        
        //TODO: KKUIView'in final'ını kaldır
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
            
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.sectionInset = UIEdgeInsets(top: -12, left: 12, bottom: 0, right: 0)
        }
    }
    
    // MARK: - Data
    func setOrderUUID(_ orderUUID: String) {
        self.orderUUID = orderUUID
        
        let group = DispatchGroup()
        group.enter()
        API.getOrderAgreements(orderUUID: orderUUID) { result in
            switch result {
            case Result.success(let agreementResponse):
                if agreementResponse.aggrements.count == 0 {
                    UIApplication.topViewController()?.view.showToast(.error, message: "action_no_agreement".localized)
                    return
                }
                
                if let agreement = agreementResponse.curentAggrements.first {
                    self.agreement = agreement
                } else {
                    self.agreement = agreementResponse.aggrements.first
                }
                
                group.leave()
                break
            case Result.failure(let error):
                self.resetAfterLoading()
                UIApplication.topViewController()?.view.showToast(.error, message: error.localizedDescription)
                group.leave()
                break
            }
        }
        
        group.notify(queue: .main) {
            guard self.agreement != nil else {
                self.resetAfterLoading()
                UIApplication.topViewController()?.view.showToast(.error, message: "action_no_agreement".localized)
                return
            }
            
            self.getOrderActions()
        }
    }
    
    private func getOrderActions() {
        API.getOrderActions(orderUUID: orderUUID!, agreementUUID: self.agreement?.uuid ?? "") { result in
            switch result {
            case Result.success(let actionResponse):
                self.actions = actionResponse.actions.filter { $0.isDisabled == false }
                self.resetAfterLoading()
                self.collectionView.reloadData()
                break
            case Result.failure(let error):
                UIApplication.topViewController()?.view.showToast(.error, message: error.localizedDescription)
                break
            }
        }
    }
    
    // MARK: - Action
    private func handleSelectedAction(_ action: OrderAction) {
        guard orderUUID != nil else { return }
        guard agreement != nil else { return }

        prepareForLoading()
        
        var parameters:[String: String] = [:]
        
        let ruleKeys = action.inputs.params.rules.keys
        let group = DispatchGroup()
        var hasEmptyParam = false
        
        for ruleString in ruleKeys {
            if let rule = OrderActionRuleType(rawValue: ruleString) {
                group.enter()
                getParameterForRule(rule) { params in
                    params?.forEach { (k,v) in parameters[k] = v }
                    if params == nil { hasEmptyParam = true }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            if hasEmptyParam {
                self.resetAfterLoading()
                return
            }
            
            API.runOrderAction(actionName: action.name, params: parameters) { result in
                switch result {
                case Result.success(_):
                    self.getOrderActions()
                    self.delegate?.didRunAction(action, error: nil)
                    break
                case Result.failure(let error):
                    self.resetAfterLoading()
                    self.delegate?.didRunAction(action, error: error)
                    break
                }
            }
        }
    }

    // MARK: - Rule
    private func getParameterForRule(_ rule: OrderActionRuleType, completion: @escaping([String: String]?) -> Void) {
        if rule == .orderUUID {
            completion([rule.rawValue: orderUUID!])
            return
        } else if rule == .agreementUUID {
            completion([rule.rawValue: agreement!.uuid])
            return
        } else if rule == .pickSecurityCode {
            let qrInputVC = QRInputCodeVC.qrInputVC(title: "picking_security_code_title".localized,
                                                    inputTitle: "picking_security_code_input_name".localized,
                                                    qrCodeKey: rule.rawValue)
            UIApplication.topViewController()?.present(qrInputVC, animated: true, completion: nil)
            
            qrInputVC.dismissCallback = { code in
                if let code = code {
                    completion([rule.rawValue: code])
                } else {
                    completion(nil)
                    return
                }
            }
            
            qrInputVC.cancelCallback = {
                self.resetAfterLoading()
            }
            return
            
        } else if rule == .deliverSecurityCode {
            let qrInputVC = QRInputCodeVC.qrInputVC(title: "picking_security_code_title".localized,
                                                    inputTitle: "picking_security_code_input_name".localized,
                                                    qrCodeKey: rule.rawValue)
            UIApplication.topViewController()?.present(qrInputVC, animated: true, completion: nil)
            
            qrInputVC.dismissCallback = { code in
                if let code = code {
                    completion([rule.rawValue: code])
                } else {
                    completion(nil)
                    return
                }
            }
            
            qrInputVC.cancelCallback = {
                self.resetAfterLoading()
            }
            return
        }

        completion(nil)
    }
    
    // MARK: - Util
    private func getConsentForAction(_ action: OrderAction) {
        let alert = UIAlertController(title: action.consentMessage, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes".localized, style: .default, handler: { alertAction in
            self.handleSelectedAction(action)
        }))
        alert.addAction(UIAlertAction(title: "no".localized, style: .cancel, handler: { action in }))
        UIApplication.topViewController()?.present(alert, animated: true)
    }
}

extension OrderActionsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderActionCVC", for: indexPath) as! OrderActionCVC
        cell.setAction(actions[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        if action.isConsentRequired {
            getConsentForAction(action)
        } else {
            handleSelectedAction(actions[indexPath.row])
        }
    }
}

extension OrderActionsView: NetworkRequestable {
    func prepareForLoading() {
        collectionView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func resetAfterLoading() {
        collectionView.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
