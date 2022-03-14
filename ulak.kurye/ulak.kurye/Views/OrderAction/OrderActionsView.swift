//
//  OrderActionsView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 14.03.2022.
//

import UIKit

protocol OrderActionsViewDelegate: AnyObject {
    func didSelectAction(_ action: OrderAction)
}

final class OrderActionsView: UIView {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: OrderActionsViewDelegate?
    private var actions: [OrderAction] = []
    
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
        
        //TODO: KKUIView'in final'ını kaldır
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
    
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 0)
        }
    }
    
    // MARK: - Data
    func setActions(_ actions: [OrderAction]) {
        self.actions = actions
        collectionView.reloadData()
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? OrderActionCVC else { return }
        cell.setAction(actions[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectAction(actions[indexPath.row])
    }
}
