//
//  SearchList.swift
//  WeatherDemo
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

struct SearchList: Codable {
    let message: String
    let count: Int
    let list: [City]
}
