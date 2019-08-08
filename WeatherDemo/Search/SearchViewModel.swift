//
//  SearchViewModel.swift
//  WeatherDemo
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

class SearchViewModel {
    let storage: CitiesStorage
    let apiClient: APIClient

    // busy loading API or finish loading
    var onLoad: ((Bool) -> Void)?
    // finsih with api loading
    var onComplete: ((Error?) -> Void)?
    
    var cities: [City] = []
    
    init(storage: CitiesStorage, apiClient: APIClient) {
        self.storage = storage
        self.apiClient = apiClient
    }
    
    func search(_ cityName: String?) {
        guard let cityName = cityName else {
            return
        }
        onLoad?(true)
        apiClient.fetchCities(cityName: cityName) {[weak self] (cities, error) in
            guard let self = self else { return }
            // make sure onLoad false is called at the end
            defer { self.onLoad?(false) }

            if let error = error {
                self.cities = []
                self.onComplete?(error)
                return
            }
            
            self.cities = cities ?? []
            self.onComplete?(nil)
        }
    }
}

// for Table View
extension SearchViewModel {
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows() -> Int {
        return max(cities.count, 1)
    }
    
    func title(at indexPath: IndexPath) -> String {
        if cities.isEmpty {
            return "No search result"
        } else {
            let city = cities[indexPath.row]
            return city.name + ", " + city.country
        }
    }
    
    func hasSearchResult() -> Bool {
        return !cities.isEmpty
    }
    
    func tapped(at indexPath: IndexPath) {
        guard hasSearchResult() else { return }
        
        let city = cities[indexPath.row]
        storage.appendCityId(id: city.id)
    }
}
