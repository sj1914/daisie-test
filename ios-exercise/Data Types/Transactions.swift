//
//  Transactions.swift
//  ios-exercise
//
//  Created by Summer Jones on 17/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import Foundation

struct Transactions {
    
    let transactions: [Transaction]
    
}

struct Transaction {
    
    let account_balance: Double
    
    let amount: String

    let created: Date

    let currency: String
    
    let description: String
    
    let time: String

//    let id: String
    
    var merchant: Merchant

    var notes: String

    let settled: Date
    
}

extension Transactions: Codable {

    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }

        guard let transactions = JSON["transactions"] as? [[String: AnyObject]] else { return nil }

        var buffer = [Transaction]()
        for transaction in transactions {
            if let t = Transaction(JSON: transaction) {
                buffer.append(t)
            }
        }

        self.transactions = buffer

    }

}

extension Transaction: Codable {

    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let account_balance = JSON["account_balance"] as? Double else { return nil }
        guard let amount = JSON["amount"] as? Double else { return nil }
        guard let created = JSON["created"] as? String else { return nil }
        guard let description = JSON["description"] as? String else { return nil }
        guard let merchant = JSON["merchant"] as? [String: AnyObject] else { return nil }
        guard let notes = JSON["notes"] as? String else { return nil }
        guard let settled = JSON["settled"] as? String else { return nil }
        guard let currency = JSON["currency"] as? String else { return nil }
        
        self.account_balance = account_balance
        self.amount = amount.formatTo(currency: currency)
        do {
            self.created = try created.formatISOStringToDate()
            self.settled = try settled.formatISOStringToDate()
            self.time = self.created.getTimeFromISODate()
        } catch {
            fatalError()
        }
        self.description = description.lowercased().capitalized
        self.notes = notes
        if let merchant = Merchant(JSON: merchant) {
            self.merchant = merchant
        } else {
            fatalError()
        }
        self.currency = currency
    }
    

}
