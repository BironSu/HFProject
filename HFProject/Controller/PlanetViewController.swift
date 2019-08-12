//
//  PlanetViewController.swift
//  HFProject
//
//  Created by Biron Su on 8/11/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PlanetViewController: UIViewController {

    @IBOutlet weak var planetsTableView: UITableView!
    private var planets = [Planets]() {
        didSet {
            DispatchQueue.main.async {
                self.planetsTableView.reloadData()
            }
        }
    }
    // Detecting if links have value to enable buttons to change value of planets array by calling the APIClient to fetch data from another URL
    private var previousLink = String()
    private var nextLink = String()
    private let apiClient = StarWarsAPIClient()
    let dateFormatterGet = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Planets"
        //Formatting the date to show Year-Month-Day (Hour:Minute:Seconds)
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatterPrint.dateFormat = "yyyy-MM-dd (HH:mm:ss)"
        planetsTableView.dataSource = self
        planetsTableView.delegate = self
        //Loads first page
        callAPIClient(input: "")
    }
    // A function to get the planets data
    private func callAPIClient(input: String) {
        apiClient.searchPlanet(apiURL: input) { result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let data):
                self.planets += data.results
                self.previousLink = data.previous ?? "null"
                self.nextLink = data.next ?? "null"
            }
        }
    }
    // functions for the infinite scrolling
    @objc private func nextResult() {
        callAPIClient(input: self.nextLink)
    }
}

extension PlanetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = planetsTableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath) as? PlanetsTableViewCell else { return PlanetsTableViewCell()}
        let cellToSet = planets[indexPath.row]
        cell.planetsNameLabel.text = ("Name: \(cellToSet.name.capitalized)")
        cell.planetsClimateLabel.text = ("Climate: \(cellToSet.climate.capitalized)")
        cell.planetsPopulationLabel.text = ("Population: \(cellToSet.population)")
        // formatting the date here to display a cleaner date format
        if let date = dateFormatterGet.date(from: cellToSet.created) {
            cell.planetsCreatedLabel.text = ("Date Created: \(dateFormatterPrint.string(from: date))")
        } else {
            cell.planetsCreatedLabel.text = "N/A"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Infinite scrolling, if it is the last row and next link is available it will call the api client using the next link.
        if indexPath.row == planets.count - 1 && nextLink != "null" {
            nextResult()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
