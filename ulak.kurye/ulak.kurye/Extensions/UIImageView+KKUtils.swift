//
//  UIImageView+KKUtils.swift
//  ulak.kurye
//
//  Created by Melih Cüneyter on 24.05.2022.
//

import Alamofire
import AlamofireImage
import UIKit

extension UIImageView {
    func setImage(withURL url: URL, placeholderImage: UIImage) {
        self.af.setImage(withURL: url, placeholderImage: placeholderImage)
    }
}
