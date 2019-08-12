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
    // Detecting if links have value to enable buttons to change value of people array by calling the APIClient to fetch data from another URL
    private var previousLink = String()
    private var nextLink = String()
    private let apiClient = StarWarsAPIClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        planetsTableView.dataSource = self
        planetsTableView.delegate = self
        callAPIClient(input: "")
    }
    // A function to get the people data as well as previous and next link
    private func callAPIClient(input: String) {
        apiClient.searchPlanet(apiURL: input) { result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let data):
                self.planets = data.results
                self.previousLink = data.previous ?? "null"
                self.nextLink = data.next ?? "null"
            }
        }
    }
    // functions for the UIButton to call when button is tapped
    @objc private func previousButton() {
        callAPIClient(input: self.previousLink)
    }
    @objc private func nextButton() {
        callAPIClient(input: self.nextLink)
    }
}

extension PlanetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < planets.count {
            guard let cell = planetsTableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath) as? PlanetsTableViewCell else { return PlanetsTableViewCell()}
            let cellToSet = planets[indexPath.row]
            cell.planetsNameLabel.text = ("Name: \(cellToSet.name.capitalized)")
            cell.planetsClimateLabel.text = ("Climate: \(cellToSet.climate.capitalized)")
            cell.planetsPopulationLabel.text = ("Population: \(cellToSet.population)")
            cell.planetsCreatedLabel.text = ("Date: \(cellToSet.created)")
            return cell
        } else {
            guard let cell = planetsTableView.dequeueReusableCell(withIdentifier: "PlanetNavCell", for: indexPath) as? PlanetsTableViewCell else { return PlanetsTableViewCell()}
            if self.previousLink != "null" {
                cell.planetsPreviousButton.isEnabled = true
                cell.planetsPreviousButton.isHidden = false
                cell.planetsPreviousButton.addTarget(self, action: #selector(previousButton), for: .touchUpInside)
            } else {
                cell.planetsPreviousButton.isEnabled = false
                cell.planetsPreviousButton.isHidden = true
            }
            if self.nextLink != "null" {
                cell.planetsNextButton.isEnabled = true
                cell.planetsNextButton.isHidden = false
                cell.planetsNextButton.addTarget(self, action: #selector(nextButton), for: .touchUpInside)
            } else {
                cell.planetsNextButton.isEnabled = false
                cell.planetsNextButton.isHidden = true
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 230
    }
}
