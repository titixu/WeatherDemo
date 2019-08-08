//
//  City.swift
//  WeatherDemo
//
//  Created by An Xu on 7/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

struct City: Codable {
    // this api payload the weather value is array decode it into array of Weather object
    private let weathers: [Weather]
    // default get the first one, assumpt only the first one is needed
    var weather: Weather? {
        return weathers.first
    }
    
    let coordinate: Coordinate
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let time: Date
    let id: Int
    let name: String
    
    private let sys: Sys
    var country: String {
        return sys.country
    }
    var sunrise: Date? {
        return sys.sunrise
    }
    var sunset: Date? {
        return sys.sunset
    }
    
    private let main: Main
    var temperature: Double {
        return main.temp
    }
    
    var pressure: Int? {
        return main.pressure
    }
    
    var humidity: Int? {
        return main.humidity
    }
    
    var temperatureMinium: Double {
        return main.tempMin
    }
    
    var temperatureMaxium: Double {
        return main.tempMax
    }
    
    let rain: Rain?
    let snow: Snow?
    
    enum CodingKeys: String, CodingKey  {
        case coordinate = "coord"
        case weathers = "weather"
        case visibility, wind, clouds
        case time = "dt"
        case id, name, sys, main, rain, snow
    }
}

struct Coordinate: Codable {
    let lon: Double
    let lat: Double
}

struct Rain: Codable {
    let lastHour: Double?
    let last3Hours: Double?
    
    enum CodingKeys: String, CodingKey  {
        case lastHour = "1h"
        case last3Hours = "3h"
    }
}

struct Snow: Codable {
    let lastHour: Double?
    let last3Hours: Double?
    
    enum CodingKeys: String, CodingKey  {
        case lastHour = "1h"
        case last3Hours = "3h"
    }
}


private struct Sys: Codable {
    let country: String
    let sunrise: Date?
    let sunset: Date?
}

private struct Main: Codable {
    let temp: Double
    let pressure: Int?
    let humidity: Int?
    let tempMin: Double
    let tempMax: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String?
    let icon: String?
}

struct Wind: Codable {
    let speed: Double?
    let degrees: Double?
    
    enum CodingKeys: String, CodingKey  {
        case speed
        case degrees = "deg"
    }
}

struct Clouds: Codable {
    let cloudinessPercentage: Int?
    
    enum CodingKeys: String, CodingKey  {
        case cloudinessPercentage = "all"
    }
}

