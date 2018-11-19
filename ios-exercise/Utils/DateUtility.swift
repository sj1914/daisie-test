//
//  DateUtility.swift
//  ios-exercise
//
//  Created by Summer Jones on 17/11/2018.
//  Copyright © 2018 Daisie. All rights reserved.
//

import UIKit

extension Date {
    func formatToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM"
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    func getTimeFromISODate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = dateFormatter.string(from: self)
        return timeString
    }
    
}
