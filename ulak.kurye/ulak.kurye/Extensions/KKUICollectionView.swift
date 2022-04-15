//
//  KKUICollectionView.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 17.03.2022.
//

import UIKit

class KKUICollectionView: UICollectionView {
    override var contentSize: CGSize{
       didSet {
           if oldValue.height != self.contentSize.height {
               invalidateIntrinsicContentSize()
           }
       }
   }

    override var intrinsicContentSize: CGSize {
       layoutIfNeeded()
       return CGSize(width: UIView.noIntrinsicMetric,
                     height: contentSize.height)
    }
}
