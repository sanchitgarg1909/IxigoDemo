//
//  AirportData.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import RealmSwift

class AirportData: Object {
    
    @objc dynamic var code: String?
    @objc dynamic var name: String?
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
    class func createObjects(dict: [String: Any]) -> [AirportData] {
        var airportMapObjects = [AirportData]()
        for key in dict.keys {
            let airportData = AirportData()
            airportData.code = key
            airportData.name = dict[key] as? String
            airportMapObjects.append(airportData)
        }
        return airportMapObjects
    }
}
