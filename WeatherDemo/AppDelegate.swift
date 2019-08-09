//
//  AppDelegate.swift
//  WeatherDemo
//
//  Created by An Xu on 7/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // default IDs to begining with: Melbourne,  Sydney, Brisbane
        let defaultCitiesIds = [2158177,2147714,2174003]
        UserDefaults.standard.firstTimeSetupIfNeeded(defaultCities: defaultCitiesIds)
        return true
    }

}

