//
//  WeatherDetailViewModel.swift
//  WeatherDemo
//
//  Created by An Xu on 9/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherDetailViewModel {
    
    var city: City
    let apiClient: APIClient
    var unitSystem: Units = .metric
    
    // busy loading API or finish loading
    var onLoad: ((Bool) -> Void)?
    // finsih with api loading
    var onComplete: ((Error?) -> Void)?

    init(city: City, apiClient: APIClient) {
        self.city = city
        self.apiClient = apiClient
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.updateCityWeather()
        }
    }
    
    func updateCityWeather() {
        onLoad?(true)
        apiClient.fetchWeather(cityID: city.id) {[weak self] (city, error) in
            defer {
                self?.onLoad?(false)
                self?.onComplete?(nil)
            }
            
            guard let self = self, let city = city else { return }
            self.city = city
        }
    }
    
    // MARK: - data source for view
    // show entire city on map
    let regionInMeters = 20000.0
    var location: CLLocation {
        return CLLocation(latitude: city.coordinate.lat, longitude: city.coordinate.lon)
    }
    
    func imageURL() -> URL? {
        return apiClient.imageURL(id: city.weather?.icon)
    }
    
    func tempertureString() -> String {
        return "\(city.temperature)\(unitSystem.symbol)"
    }
    
    func tempertureHighString() -> String {
        return "High \(city.temperatureMaxium)\(unitSystem.symbol)"
    }
    
    func tempertureLowString() -> String {
        return "Low \(city.temperatureMinium)\(unitSystem.symbol)"
    }

    func weatherDescription() -> String? {
        if let description  = city.weather?.description {
            return "Condition - \(description)"
        }
        return nil
    }
    
    func humidityString() -> String? {
        if let humidity = city.humidity {
            return "Humidity \(humidity)%"
        } else {
            return nil
        }
    }
    
    func visibilityString() -> String? {
        if let visibility = city.visibility {
            return "Visibility \(visibility) "
        } else {
            return nil
        }
    }
    
    func windSpeedString() -> String? {
        guard let wind = city.wind,
            let speed = wind.speed  else { return nil }
            return "Wind Speed \(speed) \(unitSystem.windSpeepd)"
    }
    
    func windDirectionString() -> String? {
        guard let wind = city.wind, let degress = wind.degrees else { return nil }
        return "Wind Direction \(degress) degree"
    }
    
    func cloudString() -> String? {
        if let clouds = city.clouds,
            let cloudiness = clouds.cloudinessPercentage {
            return "Cloudiness \(cloudiness)%"
        }
        return nil
    }
    
    func sunriseString() -> String? {
        if let date = city.sunrise {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return "Sunrise \(dateFormatter.string(from: date))"
        }
        return nil
    }
    
    func sunsetString() -> String? {
        if let date = city.sunset {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            return "Sunset \(dateFormatter.string(from: date))"
        }
        return nil
    }
    
}
