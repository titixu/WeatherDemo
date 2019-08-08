//
//  CitiesList.swift
//  WeatherDemo
//
//  Created by An Xu on 7/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

struct CitiesList: Codable {
    let count: Int
    let list: [City]
    
    enum CodingKeys: String, CodingKey {
        case count = "cnt"
        case list
    }
}
