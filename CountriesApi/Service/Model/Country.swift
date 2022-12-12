//
//  CountryManager.swift
//  CountriesApi
//
//  Created by Nikita Shirobokov on 28.11.22.
//

import UIKit

struct Country: Codable {
    let name: String
    let capital: String?
    let subregion: String
//    let region: Region
    let population: Int
    let area: Double?
    let nativeName: String
    let flag: String
    let independent: Bool
}

//struct Country: Codable {
//    let id: Int
//    let name, username, email: String
//    let phone, website: String
//}
