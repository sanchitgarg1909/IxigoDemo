//
//  AirlineData.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import RealmSwift

class AirlineData: Object {
    
    @objc dynamic var code: String?
    @objc dynamic var name: String?
    
    override static func primaryKey() -> String? {
        return "code"
    }

    class func createObjects(dict: [String: Any]) -> [AirlineData] {
        var airlineMapObjects = [AirlineData]()
        for key in dict.keys {
            let airlineData = AirlineData()
            airlineData.code = key
            airlineData.name = dict[key] as? String
            airlineMapObjects.append(airlineData)
        }
        return airlineMapObjects
    }
}
