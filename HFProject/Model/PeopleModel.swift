//
//  PeopleModel.swift
//  HFProject
//
//  Created by Biron Su on 8/11/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct PeopleResults : Codable {
    let next : String?
    let previous: String?
    let results : [People]
}

struct People : Codable {
    let name: String
    let hair_color: String
    let eye_color: String
    let birth_year: String
    let created: String
}
