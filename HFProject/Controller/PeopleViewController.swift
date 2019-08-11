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
    private let apiClient = StarWarsAPIClient()
    override func viewDidLoad() {
        super.viewDidLoad()
        peopleTableView.dataSource = self
        peopleTableView.delegate = self
        apiClient.searchPeople(apiURL: "") { result in
            switch result {
            case .failure(let error):
                print("error: \(error)")
            case .success(let data):
                self.people = data.results
            }
        }
    }
}

extension PeopleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > people.count {
            guard let cell = peopleTableView.dequeueReusableCell(withIdentifier: "PeopleNavCell", for: indexPath) as? PeopleTableViewCell else { return PeopleTableViewCell()}
            return cell
        }
        guard let cell = peopleTableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as? PeopleTableViewCell else { return PeopleTableViewCell()}
        let cellToSet = people[indexPath.row]
        cell.peopleNameLabel.text = cellToSet.name
        cell.peopleEyeColorLabel.text = cellToSet.eye_color
        cell.peopleHairColorLabel.text = cellToSet.hair_color
        cell.peopleBirthYearLabel.text = cellToSet.birth_year
        cell.peopleDateCreatedLabel.text = cellToSet.created
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
