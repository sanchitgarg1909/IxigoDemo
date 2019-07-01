//
//  FlightListViewController.swift
//  IxigoDemo
//
//  Created by Sanchit Garg on 29/06/19.
//  Copyright © 2019 Sanchit Garg. All rights reserved.
//

import UIKit

class FlightListViewController: UIViewController {

    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    @IBOutlet weak var takeOffSortButton: UIButton!
    @IBOutlet weak var landingSortButton: UIButton!
    @IBOutlet weak var priceSortButton: UIButton!
    
    @IBOutlet weak var businessClassSwitch: UISwitch!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var allFlightsData = [FlightInfoData]()
    lazy var filteredFlightsData = [FlightInfoData]()
    
    lazy var sortedBy: SortType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.mainCollectionView.register(UINib(nibName: "FlightListInfoCell", bundle: nil), forCellWithReuseIdentifier: FlightListInfoCell.reuseIdentifier)
        
        businessClassSwitch.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        self.navigationItem.title = "Flights"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFlightList()
    }
    
    func getFlightList() {
        activityIndicator.startAnimating()
        loaderView.isHidden = false
        NetworkController.shared.GET("sampleFlightData", parameters: [:]) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let airlineMap = data["airlineMap"] as? [String: Any] ?? [:]
                let airlineObjects = AirlineData.createObjects(dict: airlineMap)
                RealmBaseUtils.add(airlineObjects)
                let airportMap = data["airportMap"] as? [String: Any] ?? [:]
                let airportObjects = AirportData.createObjects(dict: airportMap)
                RealmBaseUtils.add(airportObjects)
                let flightsList = data["flightsData"] as? [[String: Any]] ?? []
                self.allFlightsData = FlightInfoData.createObjects(list: flightsList)
                self.filteredFlightsData = self.allFlightsData
                break
            case .failure(let error):
                self.allFlightsData = []
                self.filteredFlightsData = self.allFlightsData
                Utils.showToast(text: error.localizedDescription)
                break
            }
            self.mainCollectionView.reloadData()
            self.loaderView.isHidden = true
            self.activityIndicator.stopAnimating()

        }
    }
    
    func setupSortButtons() {
        switch sortedBy {
        case .none:
            takeOffSortButton.setTitle("Take Off", for: .normal)
            landingSortButton.setTitle("Landing", for: .normal)
            priceSortButton.setTitle("Price", for: .normal)
            break
        case .takeOffAsc:
            takeOffSortButton.setTitle("Take Off ▲", for: .normal)
            landingSortButton.setTitle("Landing", for: .normal)
            priceSortButton.setTitle("Price", for: .normal)
            break
        case .takeOffDesc:
            takeOffSortButton.setTitle("Take Off ▼", for: .normal)
            landingSortButton.setTitle("Landing", for: .normal)
            priceSortButton.setTitle("Price", for: .normal)
            break
        case .landingAsc:
            takeOffSortButton.setTitle("Take Off", for: .normal)
            landingSortButton.setTitle("Landing ▲", for: .normal)
            priceSortButton.setTitle("Price", for: .normal)
            break
        case .landingDesc:
            takeOffSortButton.setTitle("Take Off", for: .normal)
            landingSortButton.setTitle("Landing ▼", for: .normal)
            priceSortButton.setTitle("Price", for: .normal)
            break
        case .priceAsc:
            takeOffSortButton.setTitle("Take Off", for: .normal)
            landingSortButton.setTitle("Landing", for: .normal)
            priceSortButton.setTitle("Price ▲", for: .normal)
            break
        case .priceDesc:
            takeOffSortButton.setTitle("Take Off", for: .normal)
            landingSortButton.setTitle("Landing", for: .normal)
            priceSortButton.setTitle("Price ▼", for: .normal)
            break

        }
    }
    
    @IBAction func takeOffClicked(_ sender: Any) {
        if sortedBy != .takeOffAsc {
            sortedBy = .takeOffAsc
            filteredFlightsData = filteredFlightsData.sorted {($0.takeOffTime ?? 0) < ($1.takeOffTime ?? 0)}
        } else {
            sortedBy = .takeOffDesc
            filteredFlightsData = filteredFlightsData.sorted {($0.takeOffTime ?? 0) > ($1.takeOffTime ?? 0)}
        }
        setupSortButtons()
        mainCollectionView.reloadData()
    }
    
    @IBAction func landingClicked(_ sender: Any) {
        if sortedBy != .landingAsc {
            sortedBy = .landingAsc
            filteredFlightsData = filteredFlightsData.sorted {($0.landingTime ?? 0) < ($1.landingTime ?? 0)}
        } else {
            sortedBy = .landingDesc
            filteredFlightsData = filteredFlightsData.sorted {($0.landingTime ?? 0) > ($1.landingTime ?? 0)}
        }
        setupSortButtons()
        mainCollectionView.reloadData()
    }
    
    @IBAction func priceClicked(_ sender: Any) {
        if sortedBy != .priceAsc {
            sortedBy = .priceAsc
            filteredFlightsData = filteredFlightsData.sorted {($0.price ?? 0) < ($1.price ?? 0)}
        } else {
            sortedBy = .priceDesc
            filteredFlightsData = filteredFlightsData.sorted {($0.price ?? 0) > ($1.price ?? 0)}
        }
        setupSortButtons()
        mainCollectionView.reloadData()
    }
    
    @IBAction func businessSwitchClicked(_ sender: Any) {
        sortedBy = .none
        if businessClassSwitch.isOn {
            filteredFlightsData = allFlightsData.filter { $0.seatClass == SeatClass.business }
        } else {
            filteredFlightsData = allFlightsData
        }
        setupSortButtons()
        mainCollectionView.reloadData()
    }
    
}

extension FlightListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredFlightsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 50, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: mainCollectionView.bounds.size.width, height: 75)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlightListInfoCell.reuseIdentifier, for: indexPath) as! FlightListInfoCell
        
        // Configure the cell
        cell.setObject(flightInfoData: filteredFlightsData[indexPath.item])
        
        return cell
    }

}
