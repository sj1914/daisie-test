//
//  StringUtility.swift
//  ios-exercise
//
//  Created by Summer Jones on 18/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import UIKit

enum StringConvert: Error {
    case incorrectFormat
}

extension String {
    func formatISOStringToDate() throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        if let date = dateFormatter.date(from: self) {
            return date
        }
        throw StringConvert.incorrectFormat
    }
}
