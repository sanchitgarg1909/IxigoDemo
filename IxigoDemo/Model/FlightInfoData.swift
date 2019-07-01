//
//  FlightInfoData.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

class FlightInfoData {
    
    var originCode: String?
    var originName: String?
    var destinationCode: String?
    var destinationName: String?
    
    var takeOffTime: Int64?
    var takeOffTimeString: String?
    var landingTime: Int64?
    var landingTimeString: String?
    
    var durationString: String?
    
    var price: Double?
    var airlineCode: String?
    var airlineName: String?
    var seatClass: SeatClass?
    
    init(dataSource: [String: Any]) {
        originCode = dataSource["originCode"] as? String
        originName = RealmBaseUtils.get(fromEntity: AirportData.self, withPrimaryKey: originCode ?? "")?.name
        destinationCode = dataSource["destinationCode"] as? String
        destinationName = RealmBaseUtils.get(fromEntity: AirportData.self, withPrimaryKey: destinationCode ?? "")?.name

        takeOffTime = Utils.int64(fromValue: dataSource["takeoffTime"])
        takeOffTimeString = takeOffTime?.date.dateFormat(format: "HH:mm")
        landingTime = Utils.int64(fromValue: dataSource["landingTime"])
        landingTimeString = landingTime?.date.dateFormat(format: "HH:mm")
        
        let duration = ((landingTime ?? 0) - (takeOffTime ?? 0)) / 1000
        if duration > 0 {
            let (sec, min, hrs) = duration.dateComponents()
            durationString = ""
            if hrs > 0 {
                durationString?.append("\(hrs)h")
            }
            if min > 0 {
                durationString?.append("\(min)m")
            }
            if sec > 0 {
                durationString?.append("\(sec)s")
            }
        }
        
        price = Utils.double(fromValue: dataSource["price"])
        airlineCode = dataSource["airlineCode"] as? String
        airlineName = RealmBaseUtils.get(fromEntity: AirlineData.self, withPrimaryKey: airlineCode ?? "")?.name
        seatClass = SeatClass(rawValue: (dataSource["class"] as? String ?? ""))
    }
    
    class func createObjects(list: [[String: Any]]) -> [FlightInfoData] {
        var flights = [FlightInfoData]()
        for dict in list {
            let flightInfoObj = FlightInfoData(dataSource: dict)
            flights.append(flightInfoObj)
        }
        return flights
    }
}
