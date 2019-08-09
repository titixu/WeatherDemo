//
//  ViewController.swift
//  WeatherDemo
//
//  Created by An Xu on 7/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherViewController: UITableViewController {
    private let cellIdentifier = "CityWeatherCell"

    let viewModel = CitiesWeatherListViewModel(storage: UserDefaults.standard, apiClient: API())
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add refresh control
        let refreshControl = UIRefreshControl(frame: .zero)
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        // reload table view when view model finsh fetching data
        viewModel.onComplete = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // show loading indicator
        viewModel.onLoad = { [weak self] loading in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if loading {
                    self.tableView.refreshControl?.beginRefreshing()
                } else {
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchWeather()
    }

    @objc
    func pullToRefresh() {
        viewModel.fetchWeather()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
            let indexPath = tableView.indexPathForSelectedRow,
            let destinationViewController = segue.destination as? WeatherDetailViewController
        {
            let city = viewModel.city(at: indexPath)
            let weatherDetailViewModel = WeatherDetailViewModel(city: city, apiClient: viewModel.apiClient)
            destinationViewController.viewModel = weatherDetailViewModel
        }
    }

}

// MARK: - Table View Data
extension WeatherViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CityWeatherTableViewCell else {
            return UITableViewCell()
        }
    
        // TODO: change to cell view model
        let city = viewModel.city(at: indexPath)
        cell.cityNameLabel.text = city.name + " " + city.country
        cell.weatherLabel.text = city.weather?.description
        cell.tempertureLabel.text = viewModel.tempertureString(for: city)
        cell.tempertureHighLabel.text = viewModel.tempertureHighString(for: city)
        cell.tempertureLowLabel.text = viewModel.tempertureLowString(for: city)
        cell.iconImageView?.sd_setImage(with: viewModel.imageURL(for: city),
                                    placeholderImage: UIImage(named: "placeholder"))
        
        return cell
    }
}

// MARK: - Table View Delegate
extension WeatherViewController {
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.remove(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
