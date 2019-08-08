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
    
    // busy loading API or finish loading
    var onLoad: ((Bool) -> Void)?
    // finsih with api loading
    var onComplete: ((Error?) -> Void)?
    
    init(storage: CitiesStorage) {
        self.storage = storage
    }
    
}
