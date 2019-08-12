//
//  StarwarsAPIClient.swift
//  HFProject
//
//  Created by Biron Su on 8/11/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badStatusCode
    case APIError(Error)
    case JSONDecodingError(Error)
}

class StarWarsAPIClient {
    public func searchPeople(apiURL: String, completion: @escaping (Result<PeopleResults, NetworkError>) -> Void) {
        var endPointURL = apiURL
        if endPointURL == "" {
            endPointURL = "https://swapi.co/api/people/"
        }
        guard let url = URL(string: endPointURL) else {
            completion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.APIError(error)))
            } else if let data = data {
                do {
                    let peopleResults = try JSONDecoder().decode(PeopleResults.self, from: data)
                    completion(.success(peopleResults))
                } catch {
                    completion(.failure(.JSONDecodingError(error)))
                }
            }
        }
        task.resume()
    }
    public func searchPlanet(apiURL: String, completion: @escaping (Result<PlanetResults, NetworkError>) -> Void) {
        var endPointURL = apiURL
        if endPointURL == "" {
            endPointURL = "https://swapi.co/api/planets/"
        }
        guard let url = URL(string: endPointURL) else {
            completion(.failure(.badURL))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.APIError(error)))
            } else if let data = data {
                do {
                    let planetResults = try JSONDecoder().decode(PlanetResults.self, from: data)
                    completion(.success(planetResults))
                } catch {
                    completion(.failure(.JSONDecodingError(error)))
                }
            }
        }
        task.resume()
    }
}
