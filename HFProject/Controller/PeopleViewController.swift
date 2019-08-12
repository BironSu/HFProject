//
//  PeopleViewController.swift
//  HFProject
//
//  Created by Biron Su on 8/11/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class PeopleViewController: UIViewController {

    @IBOutlet weak var peopleTableView: UITableView!
    private var people = [People]() {
        didSet {
            DispatchQueue.main.async {
                self.peopleTableView.reloadData()
            }
        }
    }
    // Detecting if links have value to enable buttons to change value of people array by calling the APIClient to fetch data from another URL
    private var previousLink = String()
    private var nextLink = String()
    private let apiClient = StarWarsAPIClient()
    let dateFormatterGet = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "People"
        //Formatting the date to show Year-Month-Day (Hour:Minute:Seconds)
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatterPrint.dateFormat = "yyyy-MM-dd (HH:mm:ss)"
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        //Loads first page
        callAPIClient(input: "")
    }
    // A function to get the people data as well as previous and next link
    private func callAPIClient(input: String) {
        apiClient.searchPeople(apiURL: input) { result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let data):
                self.people += data.results
                self.previousLink = data.previous ?? "null"
                self.nextLink = data.next ?? "null"
            }
        }
    }
    // functions for the tableview to call when requirement is met
    @objc private func previousResult() {
        callAPIClient(input: self.previousLink)
    }
    @objc private func nextResult() {
        callAPIClient(input: self.nextLink)
    }
}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = peopleTableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as? PeopleTableViewCell else { return PeopleTableViewCell()}
        let cellToSet = people[indexPath.row]
        cell.peopleNameLabel.text = ("Name: \(cellToSet.name)")
        cell.peopleNameLabel.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)

        cell.peopleEyeColorLabel.text = ("Eye Color: \(cellToSet.eye_color.capitalized)")
        cell.peopleHairColorLabel.text = ("Hair Color: \(cellToSet.hair_color.capitalized)")
        cell.peopleBirthYearLabel.text = ("DOB: \(cellToSet.birth_year)")
        // formatting the date here to display a cleaner date format
        if let date = dateFormatterGet.date(from: cellToSet.created) {
            cell.peopleDateCreatedLabel.text = ("Date Created: \(dateFormatterPrint.string(from: date))")
        } else {
            cell.peopleDateCreatedLabel.text = "N/A"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Infinite scrolling, if it is the last row and next link is available it will call the api client using the next link.
        if indexPath.row == people.count - 1 && nextLink != "null" {
            nextResult()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
