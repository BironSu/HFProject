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
    // Result type in Swift 5 in a generic enum used on asychrousnous calls,
    // the Result is an enum that validates a .success or .failure against the call
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
                // TODO: using JSONDecoder() parse data to [Business] DONE
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
    
}
