//
//  VCManager.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 30/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import Foundation
import UIKit

class VCManager {
    
    // MARK: - STORYBOARDS
    
    static private let flightListBoardInstance = UIStoryboard(name: "FlightList", bundle: Bundle.main)

    // MARK: - FLIGHT LIST BOARD
    
    class func flightListVC() -> FlightListViewController {
        return VCManager.flightListBoardInstance.instantiateViewController(withIdentifier: "FlightListViewController") as! FlightListViewController
    }
}
