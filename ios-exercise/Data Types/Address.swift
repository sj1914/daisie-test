//
//  Address.swift
//  ios-exercise
//
//  Created by Summer Jones on 18/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import Foundation

struct Address: CustomStringConvertible {
    
    let street: String
    
    let city: String
    
    let country: String
    
    let latitude: Double //check precision
    
    let longitude: Double
    
    let postcode: String
    
    let region: String
    
    var description: String {
        return "\(street), \(city), \(postcode)"
    }
    
}

extension Address: Codable {
    
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let street = JSON["street"] as? String else { return nil }
        guard let city = JSON["city"] as? String else { return nil }
        guard let country = JSON["country"] as? String else { return nil }
        guard let latitude = JSON["latitude"] as? Double else { return nil }
        guard let longitude = JSON["longitude"] as? Double else { return nil }
        guard let postcode = JSON["postcode"] as? String else { return nil }
        guard let region = JSON["region"] as? String else { return nil }
        
        self.street = street
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
        self.postcode = postcode
        self.region = region
        
    }
    
}
