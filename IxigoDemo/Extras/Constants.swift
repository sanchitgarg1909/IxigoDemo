//
//  Constants.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import Foundation

let kBaseURL = "https://www.ixigo.com/"

typealias SwiftResult = Result

//Custom errors
let networkError = NSError(domain: Bundle.main.bundleIdentifier!, code: 0, userInfo: [NSLocalizedDescriptionKey: "Internet Connection seems to be offline."])
