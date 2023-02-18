//
//  StoreObserver.swift
//  CoinsConverter
//
//  Created by Yuro Mnatsakanyan on 1/17/20.
//

import StoreKit
import Foundation

protocol StoreObserverDelegate: AnyObject {
    func handleFailedState(with errorMessage: String)
    func handleRestoredStat()
    func purchasedSuccess()
    func startPurchasing()
}

class StoreObserver: NSObject {
    
    static let shared = StoreObserver()
    
    weak var delegate: StoreObserverDelegate?
    

    public func buy(_ product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    public func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func handlePurchased(_ transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            IAPHelper.sharedInstance.receiptValidation { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.purchasedSuccess()
            }
        }
    }

    private func handleFailed(_ transaction: SKPaymentTransaction) {
        var message = "\(Messages.purchaseOf) \(transaction.payment.productIdentifier) \(Messages.failed)"

        if let error = transaction.error {
            message += "\n\(Messages.error) \(error.localizedDescription)"
            debugPrint("\(Messages.error) \(error.localizedDescription)")
        }

        DispatchQueue.main.async {
            self.delegate?.handleFailedState(with: message)
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func handleRestored(_ transaction: SKPaymentTransaction) {
        DispatchQueue.main.async {
            self.delegate?.handleRestoredStat()
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
}

// MARK: - SKPaymentTransactionObserver delegate methods
extension StoreObserver: SKPaymentTransactionObserver {
    /// Called when there are transactions in the payment queue.
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing, .deferred:
                delegate?.startPurchasing()
            case .purchased, .restored:
                if transaction == transactions.last {
                    handlePurchased(transaction)
                } else {
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            case .failed:
                handleFailed(transaction)
            default:
                handleFailed(transaction)
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("paymentQueueRestoreCompletedTransactionsFinished")
    }

    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {

    }
}
