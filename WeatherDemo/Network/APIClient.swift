//
//  APIClient.swift
//  WeatherDemo
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

enum Units: String {
    case metric
    case imperial
}

protocol APIConfig {
    var baseDataURL: String { get } // base url for featching weather data
    var version: String { get } // api version
    var imageBaseURL: String { get } // base url for fetching wather image
    var token: String { get } // token for access weather data
    var units: Units { get } // Units systems, either Metric or Imperial
}

// for normal project development, we can add DevAPIConfig and stagingAPIConfig
struct ProductionAPIConfig: APIConfig {
    let baseDataURL = "https://api.openweathermap.org/data/"
    let version = "2.5"
    let imageBaseURL = "https://openweathermap.org/img/wn/"
    let token = "8b6506bf4ce1e2fd838d5bd0d179a915"
    let units = Units.metric
}


protocol APIClient {
    func fetchWeather(cityID: Int, callBack: @escaping (City?, Error?) -> Void)
    func fetchWeather(cityIDs: [Int], callBack: @escaping ([City]?, Error?) -> Void)
    func fetchCities(cityName: String, callBack: @escaping ([City]?, Error?) -> Void)
    
    func urlForOneCityWeather(cityID: Int) -> URL
    func urlForCitiesWeather(cityIDs: [Int]) -> URL
    func urlForSearchCities(cityName: String) -> URL
}

class API: APIClient {
    
    enum APIError: Error {
        case missingData
    }
    
    let decoder = JSONDecoder.api
    let config = ProductionAPIConfig()
    
    func urlForOneCityWeather(cityID: Int) -> URL {
        let urlString = config.baseDataURL
            + config.version
            + "/weather?id=\(cityID)"
            + "&units=\(config.units.rawValue)"
            + "&appid=\(config.token)"
        
        return URL(string: urlString)!
    }
    
    func urlForCitiesWeather(cityIDs: [Int]) -> URL {
        let ids = cityIDs.reduce("") { (result, id) -> String in
            if result == "" {
                return "\(id)" // no need to add comma (,) for the first id
            } else {
                return result + ",\(id)"
            }
        }
        
        let urlString = config.baseDataURL
            + config.version
            + "/group?id=\(ids)"
            + "&units=\(config.units.rawValue)"
            + "&appid=\(config.token)"
        
        return URL(string: urlString)!
    }
    
    func urlForSearchCities(cityName: String) -> URL {
        let urlString = config.baseDataURL
            + config.version
            + "/find?q=\(cityName)"
            + "&units=\(config.units.rawValue)"
            + "&appid=\(config.token)"
            + "&sort=population&cnt=30&type=like"
        
        return URL(string: urlString)!

    }
    
    // fetch weather for city id
    func fetchWeather(cityID: Int, callBack: @escaping (City?, Error?) -> Void) {
        let url = urlForOneCityWeather(cityID: cityID)
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            guard let self = self else { return }
            // check if error returned
            if let error = error { callBack(nil, error); return }
            guard let data = data else { callBack(nil, APIError.missingData); return }
            
            do {
                let city = try self.decoder.decode(City.self, from: data)
                callBack(city, nil)
            } catch let error {
                callBack(nil, error)
            }
            
        }.resume()
        
    }
    
    // Search a list of cities with city name
    func fetchCities(cityName: String, callBack: @escaping ([City]?, Error?) -> Void) {
        let url = urlForSearchCities(cityName: cityName)
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error { callBack(nil, error); return }
            guard let data = data else { callBack(nil, APIError.missingData); return }
            
            do {
                let cityList = try self.decoder.decode(SearchList.self, from: data)
                let cities = cityList.list
                callBack(cities, nil)
                
            } catch let error {
                callBack(nil, error)
            }
            
            }.resume()
    }
    
    // fetch wearher for multiple cities
    func fetchWeather(cityIDs: [Int], callBack: @escaping ([City]?, Error?) -> Void) {
        let url = urlForCitiesWeather(cityIDs: cityIDs)
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error { callBack(nil, error); return }
            guard let data = data else { callBack(nil, APIError.missingData); return }
            
            do {
                let cityList = try self.decoder.decode(CitiesList.self, from: data)
                let cities = cityList.list
                callBack(cities, nil)
                
            } catch let error {
                callBack(nil, error)
            }
            
        }.resume()
        
    }
}
