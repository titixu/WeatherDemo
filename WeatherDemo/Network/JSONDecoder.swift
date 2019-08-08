//
//  JSONDecoder.swift
//  WeatherDemo
//
//  Created by An Xu on 7/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

// api decode that auto conver snake-case to camo camel-case
extension JSONDecoder {
    static var api: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
