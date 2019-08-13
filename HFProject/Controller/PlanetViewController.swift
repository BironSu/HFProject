//
//  PlanetViewController.swift
//  HFProject
//
//  Created by Biron Su on 8/11/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit
import AVFoundation

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
    private var nextLink = String()
    private let apiClient = StarWarsAPIClient()
    var player = AVAudioPlayer()
    var tapPlayer = AVAudioPlayer()
    let dateFormatterGet = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    var playerPause = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Planets"
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "StarsBackground.jpg")!)
        self.planetsTableView.backgroundColor = .clear
        //Formatting the date to show Year-Month-Day (Hour:Minute:Seconds)
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatterPrint.dateFormat = "yyyy-MM-dd (HH:mm:ss)"
        planetsTableView.dataSource = self
        planetsTableView.delegate = self
        //Loads first page
        callAPIClient(input: "")
        self.addSongButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.playerPause = false
        self.navigationItem.rightBarButtonItem?.title = "Pause"
        self.playTheme()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.playerPause = true
        self.navigationItem.rightBarButtonItem?.title = "Play"
        self.playTheme()
    }
    // Function to play sound
    func PlaySound() {
        do {
            let audioPath = Bundle.main.path(forResource: "LightsaberSwing", ofType: "wav")
            try tapPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!) as URL)
        } catch {
            print("Error !")
        }
        tapPlayer.play()
    }
    func addSongButton() {
        let play = UIBarButtonItem(title: "Pause", style: .plain, target: self, action: #selector(playTapped))
        navigationItem.rightBarButtonItem = play
    }
    @objc func playTapped(_ sender: UIBarButtonItem) {
        if sender.title == "Play" {
            playTheme()
            sender.title = "Pause"
        } else {
            playTheme()
            sender.title = "Play"
        }
    }
    func playTheme() {
        if playerPause == false {
            do {
                let audioPath = Bundle.main.path(forResource: "SWBattleTheme", ofType: "mp3")
                try player = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!) as URL)
                player.volume = 0.25
            } catch {
                print("Error !")
            }
            player.play()
            playerPause = true
        } else {
            playerPause = false
            player.pause()
        }
    }
    // A function to get the planets data
    private func callAPIClient(input: String) {
        apiClient.searchPlanet(apiURL: input) { result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let data):
                self.planets += data.results
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
        // Editing the looks of each label in every cell with a UILabel Extension
        cell.backgroundColor = .clear
        cell.planetsNameLabel.customize()
        cell.planetsClimateLabel.customize()
        cell.planetsPopulationLabel.customize()
        cell.planetsCreatedLabel.customize()
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Infinite scrolling, if it is the last row and next link is available it will call the api client using the next link.
        if indexPath.row == planets.count - 1 && nextLink != "null" {
            nextResult()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        PlaySound()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
