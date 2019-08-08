//
//  APIs.swift
//  LogicTests
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import XCTest

class APIs: XCTestCase {
    
    func testProductionAPIConfig() {
        let apiConfig = ProductionAPIConfig()
        XCTAssertEqual(apiConfig.baseDataURL, "https://api.openweathermap.org/data/")
        XCTAssertEqual(apiConfig.version, "2.5")
        XCTAssertEqual(apiConfig.imageBaseURL, "https://openweathermap.org/img/wn/")
        XCTAssertEqual(apiConfig.units, Units.metric)
        XCTAssertEqual(apiConfig.token, "8b6506bf4ce1e2fd838d5bd0d179a915")
    }
    
    func testProductionURLs() {
        let api = API()

        let cityWeatherURLString = "https://api.openweathermap.org/data/2.5/weather?id=2158177&units=metric&appid=8b6506bf4ce1e2fd838d5bd0d179a915"
        var urlString = api.urlForOneCityWeather(cityID: 2158177).absoluteString
        XCTAssertEqual(cityWeatherURLString, urlString)
        
        let citiesWeatherURLString = "https://api.openweathermap.org/data/2.5/group?id=2158177,2147714,2174003&units=metric&appid=8b6506bf4ce1e2fd838d5bd0d179a915"
        
        urlString = api.urlForCitiesWeather(cityIDs: [2158177, 2147714, 2174003]).absoluteString
        XCTAssertEqual(citiesWeatherURLString, urlString)
        
        let searchCityURlString = "https://api.openweathermap.org/data/2.5/find?q=Melbourne&units=metric&appid=8b6506bf4ce1e2fd838d5bd0d179a915&sort=population&cnt=30&type=like"
        
        urlString = api.urlForSearchCities(cityName: "Melbourne").absoluteString
        XCTAssertEqual(searchCityURlString, urlString)
    }
}


class APIIntegrationTest: XCTestCase {
    let api = API()
    var expectation: XCTestExpectation?
    
    // test fetch weather for Melboirne
    func testFetchCity() {
        let expectation = XCTestExpectation(description: "Fetch a city weather")
        
        api.fetchWeather(cityID: 2158177) { (city, error) in
            expectation.fulfill()
            
            XCTAssertNotNil(city)
            XCTAssertNil(error)
            
            let city = city!
            XCTAssertEqual(city.id, 2158177)
            XCTAssertEqual(city.name, "Melbourne")
        }
        
        wait(for: [expectation], timeout: 8)
    }
    
    // test fetch more than one city
    func testFetchCities() {
        let expectation = XCTestExpectation(description: "Fetch multiple cities weather")
        
        api.fetchWeather(cityIDs: [2158177,2147714,2174003]) { (cities, error) in
            expectation.fulfill()
            
            XCTAssertNotNil(cities)
            XCTAssertNil(error)
            
            var city = cities!.first!
            XCTAssertEqual(city.id, 2158177)
            XCTAssertEqual(city.name, "Melbourne")
            
            city = cities!.last!
            XCTAssertEqual(city.id, 2174003)
            XCTAssertEqual(city.name, "Brisbane")
        }
        
        wait(for: [expectation], timeout: 8)

    }
    
    // test search city with name Melbourne
    func testSearchCities() {
        let expectation = XCTestExpectation(description: "Fetch multiple cities with name")
        
        api.fetchCities(cityName: "Melbourne") { (cities, error) in
            expectation.fulfill()
            
            XCTAssertNotNil(cities)
            XCTAssertNil(error)
            
            var city = cities!.first!
            XCTAssertEqual(city.id, 2158177)
            XCTAssertEqual(city.name, "Melbourne")
            XCTAssertEqual(city.country, "AU")
            
            city = cities!.last!
            XCTAssertEqual(city.id, 4634931)
            XCTAssertEqual(city.name, "Melbourne")
            XCTAssertEqual(city.country, "US")
        }
        
        wait(for: [expectation], timeout: 8)
        
    }
}
