//
//  WeatherDetailViewController.swift
//  WeatherDemo
//
//  Created by An Xu on 9/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SDWebImage

class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherIcon: SDAnimatedImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var temperatureHigh: UILabel!
    @IBOutlet weak var temperatureLow: UILabel!
    @IBOutlet weak var humidity: UILabel!
    @IBOutlet weak var visibility: UILabel!
    @IBOutlet weak var windSpeed: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var cloud: UILabel!
    
    @IBOutlet weak var sunrise: UILabel!
    @IBOutlet weak var sunset: UILabel!
    
    @IBOutlet var loadingView: UIView!
    
    var viewModel: WeatherDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.onLoad = { [weak self] onload in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if onload {
                    self.view.addSubview(self.loadingView)
                    NSLayoutConstraint.activate([
                        self.loadingView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        self.loadingView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100.0),
                        self.loadingView.widthAnchor.constraint(equalToConstant: 240.0),
                        self.loadingView.heightAnchor.constraint(equalToConstant: 128.0)
                        ])
                } else {
                    self.loadingView.removeFromSuperview()
                }
            }
        }
        
        viewModel.onComplete = {[weak self] _ in
            DispatchQueue.main.async {
                self?.updateDetails()
            }
        }
        
        viewModel.updateCityWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCityLocation()
    }
    
    private func showCityLocation() {
        let region = MKCoordinateRegion.init(center: viewModel.location.coordinate, latitudinalMeters: viewModel.regionInMeters, longitudinalMeters: viewModel.regionInMeters)
        mapView.setRegion(region, animated: false)
    }
    
    private func updateDetails() {
        cityName.text = viewModel.city.name
        weatherIcon.sd_setImage(with: viewModel.imageURL())
        weatherDescription.text = viewModel.weatherDescription()
        temperature.text = viewModel.tempertureString()
        temperatureHigh.text = viewModel.tempertureHighString()
        temperatureLow.text = viewModel.tempertureLowString()
        humidity.text = viewModel.humidityString()
        visibility.text = viewModel.visibilityString()
        windSpeed.text = viewModel.windSpeedString()
        windDirection.text = viewModel.windDirectionString()
        cloud.text = viewModel.cloudString()
        sunrise.text = viewModel.sunriseString()
        sunset.text = viewModel.sunsetString()
    }
}
