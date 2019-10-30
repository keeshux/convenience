//
//  InApp.swift
//  Convenience
//
//  Created by Davide De Rosa on 9/9/19.
//  Copyright © 2019 Davide De Rosa. All rights reserved.
//

import Foundation
import StoreKit

public enum InAppPurchaseResult {
    case success
    
    case failure
    
    case cancelled
}

public class InApp<PID: Hashable & RawRepresentable>: NSObject,
        SKProductsRequestDelegate, SKPaymentTransactionObserver
        where PID.RawValue == String {

    public typealias ProductObserver = ([PID: SKProduct]) -> Void
    
    public typealias TransactionObserver = (InAppPurchaseResult, Error?) -> Void
    
    public typealias RestoreObserver = (Bool, PID?, Error?) -> Void
    
    private var productsMap: [PID: SKProduct]
    
    public var products: [SKProduct] {
        return [SKProduct](productsMap.values)
    }
    
    private var productObservers: [ProductObserver]
    
    private var transactionObservers: [String: TransactionObserver]
    
    private var restoreObservers: [RestoreObserver]
    
    public override init() {
        productsMap = [:]
        productObservers = []
        transactionObservers = [:]
        restoreObservers = []
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    public func requestProducts(withIdentifiers identifiers: [PID], completionHandler: ProductObserver?) {
        let req = SKProductsRequest(productIdentifiers: Set(identifiers.map { $0.rawValue }))
        req.delegate = self
        if let observer = completionHandler {
            productObservers.append(observer)
        }
        req.start()
    }

    @discardableResult
    public func purchase(productWithIdentifier productIdentifier: PID, completionHandler: @escaping TransactionObserver) -> Bool {
        guard let product = productsMap[productIdentifier] else {
            return false
        }
        purchase(product: product, completionHandler: completionHandler)
        return true
    }

    public func purchase(product: SKProduct, completionHandler: @escaping TransactionObserver) {
        let queue = SKPaymentQueue.default()
        let payment = SKPayment(product: product)
        transactionObservers[product.productIdentifier] = completionHandler
        queue.add(payment)
    }
    
    public func restorePurchases(completionHandler: @escaping RestoreObserver) {
        let queue = SKPaymentQueue.default()
        restoreObservers.append(completionHandler)
        queue.restoreCompletedTransactions()
    }
    
    public func product(withIdentifier productIdentifier: PID) -> SKProduct? {
        return productsMap[productIdentifier]
    }

    // MARK: SKProductsRequestDelegate

    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.receiveProducts(response.products)
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        transactionObservers.removeAll()
    }
    
    private func receiveProducts(_ products: [SKProduct]) {
        productsMap.removeAll()
        for p in products {
            guard let pid = PID(rawValue: p.productIdentifier) else {
                continue
            }
            productsMap[pid] = p
        }
        productObservers.forEach { $0(productsMap) }
        productObservers.removeAll()
    }

    // MARK: SKPaymentTransactionObserver

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        let currentRestoreObservers = restoreObservers
        
        for tx in transactions {
            let productIdentifier = tx.payment.productIdentifier
            let observer = transactionObservers[productIdentifier]
            
            switch tx.transactionState {
            case .purchased:
                queue.finishTransaction(tx)
                DispatchQueue.main.async {
                    observer?(.success, nil)
                }

            case .restored:
                queue.finishTransaction(tx)
                DispatchQueue.main.async {
                    observer?(.success, nil)
                    for r in currentRestoreObservers {
                        guard let pid = PID(rawValue: productIdentifier) else {
                            continue
                        }
                        r(false, pid, nil)
                    }
                }
                
            case .failed:
                queue.finishTransaction(tx)
                if let skError = tx.error as? SKError, skError.code == .paymentCancelled {
                    DispatchQueue.main.async {
                        observer?(.cancelled, nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        observer?(.failure, tx.error)
                        for r in currentRestoreObservers {
                            guard let pid = PID(rawValue: productIdentifier) else {
                                continue
                            }
                            r(false, pid, tx.error)
                        }
                    }
                }
                
            default:
                break
            }
        }
    }

    public func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for r in restoreObservers {
            r(true, nil, nil)
        }
        restoreObservers.removeAll()
    }
    
    public func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        for r in restoreObservers {
            r(true, nil, error)
        }
        restoreObservers.removeAll()
    }
}

extension SKProduct {
    private var localizedCurrencyFormatter: NumberFormatter {
        let fmt = NumberFormatter()
        fmt.locale = priceLocale
        fmt.numberStyle = .currency
        return fmt
    }

    public var localizedPrice: String? {
        return localizedCurrencyFormatter.string(from: price)
    }
}
