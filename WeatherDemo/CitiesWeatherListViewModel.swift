//
//  CitiesWeatherListViewModel.swift
//  WeatherDemo
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

class CitiesWeatherListViewModel {
    let storage: CitiesStorage
    let apiClient: APIClient
    
    // busy loading API or finish loading
    var onLoad: ((Bool) -> Void)?
    // finsih with api loading
    var onComplete: ((Error?) -> Void)?
    
    var cities: [City] = []
    
    var unitSystem: Units = .metric
    
    init(storage: CitiesStorage, apiClient: APIClient) {
        self.storage = storage
        self.apiClient = apiClient
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.fetchWeather()
        }
    }
    
    func fetchWeather() {
        onLoad?(true)
        apiClient.fetchWeather(cityIDs: storage.cityIDs) {[weak self] (cities, error) in
            guard let self = self else { return }
            // make sure onLoad false is called at the end
            defer { self.onLoad?(false) }
            if let error = error {
                self.onComplete?(error)
                return
            }
            
            guard let cities = cities else {
                self.onComplete?(nil)
                return
            }
            
            // sort the cities by name
            self.cities = cities.sorted(by: { (left, right) -> Bool in
                left.name < right.name
            })
            self.onComplete?(nil)
        }
    }
    
}

// for Table View
extension CitiesWeatherListViewModel {
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return cities.count
    }
    
    func city(at indexPath: IndexPath) -> City {
        return cities[indexPath.row]
    }
    
    func tempertureString(for city: City) -> String {
        return "\(city.temperature)\(unitSystem.symbol)"
    }
    
    func tempertureHighString(for city: City) -> String {
        return "High \(city.temperatureMaxium)\(unitSystem.symbol)"
    }
    
    func tempertureLowString(for city: City) -> String {
        return "Low \(city.temperatureMinium)\(unitSystem.symbol)"
    }
    
    func imageURL(for city: City) -> URL? {
        return apiClient.imageURL(id: city.weather?.icon)
    }
    
    func remove(at indexPath: IndexPath) {
        let city = cities[indexPath.row]
        storage.removeCityId(id: city.id)
        cities.remove(at: indexPath.row)
    }
}
