//
//  Country.swift
//  Challenge5
//
//  Created by Ed Yama on 28/07/21.
//

import Foundation

struct Country: Codable {
    
    let name: String
    let capital: String
    let region: String
    let subregion: String
    let population: Int
    let demonym: String
    let area: Double?
    let gini: Double?
}
