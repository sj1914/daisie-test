//
//  User.swift
//  ios-exercise
//
//  Created by Summer Jones on 18/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import Foundation

struct User {
    
    let firstName: String
    
    let lastName: String
    
    let id: String
    
}

extension User: Decodable {
    
    init?(JSON: Any) {
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        
        guard let firstName = JSON["firstName"] as? String else { return nil }
        guard let lastName = JSON["lastName"] as? String else { return nil }
        guard let id = JSON["id"] as? String else { return nil }
        
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
    }
    
}
