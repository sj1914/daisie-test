//
//  DoubleUtility.swift
//  ios-exercise
//
//  Created by Summer Jones on 17/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import UIKit

extension Double {
    func formatToCurrencyString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        let formattedNumber = formatter.string(from: NSNumber(value: self))
        return formattedNumber!
    }
}
