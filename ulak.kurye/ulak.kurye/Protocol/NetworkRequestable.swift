//
//  NetworkRequestable.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 7.03.2022.
//

import Foundation

protocol NetworkRequestable {
    func prepareForLoading()
    func resetAfterLoading()
}
