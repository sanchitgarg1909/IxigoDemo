//
//  FlightListInfoCell.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 29/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import UIKit

class FlightListInfoCell: UICollectionViewCell {

    @IBOutlet weak var flightImageView: UIImageView!
    @IBOutlet weak var flightNameLabel: UILabel!
    @IBOutlet weak var originNameLabel: UILabel!
    @IBOutlet weak var destinationNameLabel: UILabel!
    @IBOutlet weak var takeOffTimeLabel: UILabel!
    @IBOutlet weak var landingTimeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    static var reuseIdentifier = "FlightListInfoCell"

    func setObject(flightInfoData: FlightInfoData) {
        flightNameLabel.text = flightInfoData.airlineName
        originNameLabel.text = flightInfoData.originName
        destinationNameLabel.text = flightInfoData.destinationName
        takeOffTimeLabel.text = "\(flightInfoData.takeOffTimeString ?? "NA")"
        landingTimeLabel.text = "\(flightInfoData.landingTimeString ?? "NA")"
        priceLabel.text = "₹\(String(format: "%.0f", flightInfoData.price ?? 0))"
        durationLabel.text = "\(flightInfoData.durationString ?? "") • \(flightInfoData.seatClass?.rawValue ?? "")"
    }
}
