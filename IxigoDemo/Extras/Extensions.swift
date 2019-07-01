//
//  Extensions.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import Foundation

extension Int64 {
    var date : Date {
        return Date(timeIntervalSince1970: Double(self / 1000))
    }
    
    func dateComponents() -> (seconds: Int64, minutes: Int64, hours: Int64) {
        return ((self % 3600) % 60, (self % 3600) / 60, self/3600)
    }

}

extension Date {
    func dateFormat(format: String) -> String {
        let shortDateFormatter = DateFormatter()
        shortDateFormatter.dateFormat = format
        return shortDateFormatter.string(from: self)
    }
}
