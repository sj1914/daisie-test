//
//  Configuration.swift
//  ios-exercise
//
//  Created by Summer Jones on 18/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import Foundation

enum API {
    
//    static let APIKey = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    static let BaseURL = URL(string: "https://daisie-ios-exercise.glitch.me/")!
    
    static var AuthenticatedBaseURL: URL {
        return BaseURL
    }
    
}
