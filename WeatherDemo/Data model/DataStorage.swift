//
//  DataStorage.swift
//  WeatherDemo
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation

protocol CitiesStorage {
    // store a list of city IDs for user, or get a list stored city IDs
    var cityIDs: [Int] { get set }
    
    // if it is first time of running the storage, insert some default ids
    func firstTimeSetupIfNeeded(defaultCities ids: [Int]) -> Void
    
    // store an new city id
    func appendCityId(id: Int) -> Void
    
    // remove a city id from storage
    func removeCityId(id: Int)
}

// storage it locally
extension UserDefaults: CitiesStorage {
    
    private var key: String {
        return "CityIDs"
    }
    
    var cityIDs: [Int] {
        get {
            guard let cityIds = object(forKey: key) as? [Int]  else { return [] }
            return cityIds
        }
        set {
            set(newValue, forKey: key)
            synchronize()
        }
    }
    
    func firstTimeSetupIfNeeded(defaultCities ids: [Int]) -> Void {
        // if the key is not in the user default insert ids
        guard dictionaryRepresentation().keys.contains(key) == false else { return }
        cityIDs = ids
    }
    
    func appendCityId(id: Int) {
        guard !cityIDs.contains(id) else { return }
        
        var ids = cityIDs
        ids.append(id)
        set(ids, forKey: key)
        synchronize()
    }
    
    func removeCityId(id: Int) {
        var ids = cityIDs
        ids.removeAll(where: { $0 == id })
        set(ids, forKey: key)
        synchronize()
    }
    
    
}
