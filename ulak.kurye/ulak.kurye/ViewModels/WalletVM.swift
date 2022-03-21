//
//  WalletVM.swift
//  ulak.kurye
//
//  Created by Mehmet Karagöz on 21.03.2022.
//

import Foundation

struct WalletVM {
    let balance: String
    let transactions: [WalletTransactionVM]
    
    private var walletResponse: WalletResponse
    
    init(walletResponse: WalletResponse) {
        self.walletResponse = walletResponse
        
        balance = walletResponse.wallet.balance
        
        var tempTransactions: [WalletTransactionVM] = []
        for transaction in walletResponse.transactions {
            if let earning = transaction.meta.earning, earning.isVisible == true, earning.value > 0 {
                tempTransactions.append(WalletTransactionVM(transaction: transaction, earning: earning))
            } else if let preEarning = transaction.meta.prepayEarning, preEarning.isVisible == true, preEarning.value > 0 {
                tempTransactions.append(WalletTransactionVM(transaction: transaction, earning: preEarning))
            }
        }
        
        transactions = tempTransactions
    }
}

struct WalletTransactionVM {
    let balance: String
    let type: String
    let date: String
    let orderUUID: String
    
    init(transaction: WalletTransaction, earning: WalletTransactionEarning) {
        balance = earning.value.currencyValue(earning.currency)
        type = transaction.type.localized
        date = transaction.createdAt.serverDate?.longDateString ?? "-"
        orderUUID = transaction.meta.orderUUID
    }
}
