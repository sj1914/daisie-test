//
//  Merchant.swift
//  ios-exercise
//
//  Created by Summer Jones on 18/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import Foundation
import UIKit


struct Merchant {
    
    let address: Address
    
    var created: Date
    
//    let id: String
    
    var logoURL: URL? = nil
    
    let name: String
    
    let category: String
    
}

extension Merchant: Decodable {
    
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let address = JSON["address"] as? [String: AnyObject] else { return nil }
        guard let created = JSON["created"] as? String else { return nil }
        guard let imageURLString = JSON["logo"] as? String else { return nil }
        guard let name = JSON["name"] as? String else { return nil }
        guard let category = JSON["category"] as? String else { return nil }
        
        if let logoURL = URL(string: imageURLString) {
            self.logoURL = logoURL
        }
        do {
            self.created = try created.formatISOStringToDate()
        } catch {
            fatalError()
        }
        self.name = name
        self.category = category
        if let address = Address(JSON: address) {
            self.address = address
        } else {
            fatalError()
        }
    }
    
}

