//
//  WalletVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import Foundation
import UIKit

struct WalletVM {
    let uuid: String
    var balance: String
    let payableBalance: Double
    let transactions: [WalletTransactionVM]
    let transferButtonAlpha: Double
    
    private var walletResponse: WalletResponse
    
    init(walletResponse: WalletResponse) {
        self.walletResponse = walletResponse
        
        uuid = walletResponse.wallet.uuid
        balance = walletResponse.wallet.balance
        payableBalance = Double(balance) ?? 0.0
        balance = payableBalance.currencyValue(walletResponse.wallet.currency)
        
        if payableBalance == 0 {
            transferButtonAlpha = 0.5
        } else {
            transferButtonAlpha = 1.0
        }
        
        var tempTransactions: [WalletTransactionVM] = []
        for transaction in walletResponse.transactions {
            if Double(transaction.amount) != 0 {
                tempTransactions.append(WalletTransactionVM(transaction: transaction))
            }
        }
        
        transactions = tempTransactions
    }
}

struct WalletTransactionVM {
    let type: String
    let amount: String
    let date: String
    let orderUUID: String?
    let imageTintColor: UIColor
    
    init(transaction: WalletTransaction) {
        type = transaction.type.localized
        
        var doubleAmount = Double(transaction.amount) ?? 0
        doubleAmount = doubleAmount / 100.0
        amount = doubleAmount.currencyValue(transaction.currency)

        date = transaction.createdAt.serverDate?.longDateString ?? "-"
        orderUUID = transaction.meta.orderUUID
        
        if type == "withdraw" {
            imageTintColor = .init(named: "ulk-red-bold")!
        } else {
            imageTintColor = .init(named: "ulk-green")!
        }
    }
}
