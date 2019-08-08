//
//  LogicTests.swift
//  LogicTests
//
//  Created by An Xu on 7/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import XCTest

func loadFile(name: String, ext: String) -> Data {
    let bundle = Bundle(for: CityTests.self)
    let url = bundle.url(forResource: name, withExtension: ext)!
    return try! Data.init(contentsOf: url)
}

// test Melbourne city weather payload
class CityTests: XCTestCase {

    let data = loadFile(name: "city", ext: ".json")
    
    func testCity() {
        let city = try! JSONDecoder.api.decode(City.self, from: data)
        XCTAssertEqual(city.weather!.main, "Clouds")
        XCTAssertEqual(city.weather!.description, "broken clouds")
        XCTAssertEqual(city.country, "AU")
        XCTAssertEqual(city.sunrise, Date(timeIntervalSinceReferenceDate: 1565126104))
        XCTAssertEqual(city.sunset, Date(timeIntervalSinceReferenceDate: 1565163419))
        XCTAssertEqual(city.id, 2158177)
        XCTAssertEqual(city.name, "Melbourne")
        XCTAssertEqual(city.wind!.speed, 5.1)
        XCTAssertEqual(city.wind!.degrees, 360)
        XCTAssertEqual(city.visibility, 10000)
        XCTAssertEqual(city.clouds!.cloudinessPercentage, 75)
        XCTAssertEqual(city.time, Date(timeIntervalSinceReferenceDate: 1565164861))
        
        XCTAssertEqual(city.temperature, 283.96)
        XCTAssertEqual(city.pressure, 1006)
        XCTAssertEqual(city.humidity, 66)
        XCTAssertEqual(city.temperatureMinium, 282.04)
        XCTAssertEqual(city.temperatureMaxium, 285.15)
    }
}

// Test a list of cities api payload
class CitiesListTests: XCTestCase {
    let data = loadFile(name: "cities", ext: "json")
    
    func testCitiesList() {
        
        let listOfCities = try! JSONDecoder.api.decode(CitiesList.self, from: data)
        XCTAssertEqual(listOfCities.count, 3)
        
        // test Melbourne city weather payload
        var city = listOfCities.list[0]
        XCTAssertEqual(city.weather!.main, "Clouds")
        XCTAssertEqual(city.weather!.description, "broken clouds")
        XCTAssertEqual(city.country, "AU")
        XCTAssertEqual(city.sunrise, Date(timeIntervalSinceReferenceDate: 1565126104))
        XCTAssertEqual(city.sunset, Date(timeIntervalSinceReferenceDate: 1565163419))
        XCTAssertEqual(city.id, 2158177)
        XCTAssertEqual(city.name, "Melbourne")
        XCTAssertEqual(city.wind!.speed, 3.6)
        XCTAssertEqual(city.wind!.degrees, 40)
        XCTAssertEqual(city.visibility, 10000)
        XCTAssertEqual(city.clouds!.cloudinessPercentage, 75)
        XCTAssertEqual(city.time, Date(timeIntervalSinceReferenceDate: 1565158185))
        
        // test Sydney city weather payload
        city = listOfCities.list[1]
        XCTAssertEqual(city.weather!.main, "Clear")
        XCTAssertEqual(city.weather!.description, "clear sky")
        XCTAssertEqual(city.country, "AU")
        XCTAssertEqual(city.sunrise, Date(timeIntervalSinceReferenceDate: 1565124180))
        XCTAssertEqual(city.sunset, Date(timeIntervalSinceReferenceDate: 1565162344))
        XCTAssertEqual(city.id, 2147714)
        XCTAssertEqual(city.name, "Sydney")
        XCTAssertEqual(city.wind!.speed, 4.1)
        XCTAssertEqual(city.wind!.degrees, 60)
        XCTAssertEqual(city.visibility, 10000)
        XCTAssertEqual(city.clouds!.cloudinessPercentage, 0)
        XCTAssertEqual(city.time, Date(timeIntervalSinceReferenceDate: 1565158185))
    }
}

// Test the search list api payload
class SearchListTest: XCTestCase {
    let data = loadFile(name: "search", ext: "json")
    
    func testSearchList() {
        let searchlist = try! JSONDecoder.api.decode(SearchList.self, from: data)
        XCTAssertEqual(searchlist.count, 14)
        XCTAssertEqual(searchlist.message, "like")
        
        // test first city in the list
        var city = searchlist.list.first!
        XCTAssertEqual(city.weather!.main, "Clouds")
        XCTAssertEqual(city.weather!.description, "scattered clouds")
        XCTAssertEqual(city.country, "AU")
        XCTAssertNil(city.sunrise)
        XCTAssertNil(city.sunset)
        XCTAssertEqual(city.id, 2158177)
        XCTAssertEqual(city.name, "Melbourne")
        XCTAssertEqual(city.wind!.speed, 5.7)
        XCTAssertEqual(city.wind!.degrees, 10)
        XCTAssertNil(city.visibility)
        XCTAssertEqual(city.clouds!.cloudinessPercentage, 40)
        XCTAssertEqual(city.time, Date(timeIntervalSinceReferenceDate: 1565161756))
        
        // test last city in the list
        city = searchlist.list.last!
        XCTAssertEqual(city.weather!.main, "Rain")
        XCTAssertEqual(city.weather!.description, "light rain")
        XCTAssertEqual(city.country, "US")
        XCTAssertNil(city.sunrise)
        XCTAssertNil(city.sunset)
        XCTAssertEqual(city.id, 4634931)
        XCTAssertEqual(city.name, "Melbourne")
        XCTAssertEqual(city.wind!.speed, 1.5)
        XCTAssertEqual(city.wind!.degrees, 200)
        XCTAssertNil(city.visibility)
        XCTAssertEqual(city.clouds!.cloudinessPercentage, 90)
        XCTAssertEqual(city.time, Date(timeIntervalSinceReferenceDate: 1565161898))
    }
    
}
