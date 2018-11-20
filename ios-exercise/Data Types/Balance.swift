//
//  Balance.swift
//  ios-exercise
//
//  Created by Summer Jones on 17/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

struct Balance {
    
    let balance: String
    
    let currency: String
    
    let spent_today: Double
    
}

extension Balance: Decodable {
    
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let balance = JSON["balance"] as? Double else { return nil }
        guard let currency = JSON["currency"] as? String else { return nil }
        guard let spent_today = JSON["spent_today"] as? Double else { return nil }
        
        self.balance = balance.formatTo(currency: currency)
        self.currency = currency
        self.spent_today = spent_today
    }
    
}
