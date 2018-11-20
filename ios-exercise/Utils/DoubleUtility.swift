//
//  DoubleUtility.swift
//  ios-exercise
//
//  Created by Summer Jones on 17/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import UIKit

extension Double {
    func formatTo(currency: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        var formattedNumber = formatter.string(from: NSNumber(value: self))
        var currencySymbol = getSymbol(forCurrencyCode: currency)
        if self < 0 {
            formattedNumber?.remove(at: currencySymbol!.startIndex)
            currencySymbol = "-\(currencySymbol!)"
        }
        return "\(currencySymbol!)\(formattedNumber!)"
    }
}

private func getSymbol(forCurrencyCode code: String) -> String? {
    let locale = NSLocale(localeIdentifier: code)
    if locale.displayName(forKey: .currencySymbol, value: code) == code {
        let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
        return newlocale.displayName(forKey: .currencySymbol, value: code)
    }
    return locale.displayName(forKey: .currencySymbol, value: code)
}
