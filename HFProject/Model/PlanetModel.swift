//
//  PlanetModel.swift
//  HFProject
//
//  Created by Biron Su on 8/11/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

struct PlanetResults : Codable {
    let next : String?
    let previous: String?
    let results : [Planets]
}

struct Planets : Codable {
    let name : String
    let climate : String
    let population : String
    let created : String
}
