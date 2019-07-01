//
//  Utils.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import Foundation
import Toaster

class Utils {
    
    // MARK: - DISPATCH QUEUE UTILS
    
    class func performBackground(block: @escaping ()->()) {
        if Thread.current.isMainThread {
            DispatchQueue.global(qos: .background).async {
                autoreleasepool {
                    block()
                }
            }
        } else {
            autoreleasepool {
                block()
            }
        }
    }
    
    class func performMain(block: @escaping ()->()) {
        DispatchQueue.main.async(execute: block)
    }
    
    class func performAfter(_ timeInterval: Double, block: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(timeInterval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: block)
    }
    
    // MARK: - CONVERSION UTILS
    
    class func int64(fromValue value: Any?, defaultValue: Int64 = 0) -> Int64 {
        if value == nil {
            return defaultValue
        } else if let intValue = value as? Int64 {
            return intValue
        } else if let intValue = value as? Int {
            return Int64(intValue)
        } else if let stringValue = value as? String {
            if let intValue = Int64(stringValue) {
                return intValue
            } else {
                return defaultValue
            }
        } else {
            return defaultValue
        }
    }
    
    class func double(fromValue value: Any?, defaultValue: Double = 0) -> Double {
        if value == nil {
            return defaultValue
        } else if let floatValue = value as? Float {
            return Double(floatValue)
        } else if let doubleValue = value as? Double {
            return doubleValue
        } else if let intValue = value as? Int {
            return Double(intValue)
        } else if let stringValue = value as? String {
            if let doubleValue = Double(stringValue) {
                return doubleValue
            } else {
                return defaultValue
            }
        } else {
            return defaultValue
        }
    }
    
    // MARK: - TOAST
    
    class func showToast(text: String?, duration: TimeInterval = 3) {
        if text != "cancelled" {
            Utils.performMain {
                Toast(text: text, delay: 0, duration: duration).show()
            }
        }
    }
}
