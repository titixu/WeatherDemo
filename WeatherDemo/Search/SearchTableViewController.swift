//
//  SearchTableViewController.swift
//  WeatherDemo
//
//  Created by An Xu on 8/8/19.
//  Copyright © 2019 An Xu. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var loadingView: UIView!
    
    let viewModel = SearchViewModel(storage: UserDefaults.standard, apiClient: API())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        viewModel.onComplete = { [weak self] _ in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()                
            }
        }
        
        self.tableView.refreshControl = UIRefreshControl(frame: .zero)
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
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.search(searchBar.text)
        searchBar.resignFirstResponder()
    }
}

// MARK: - table view data Source
extension SearchTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSection()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchListCell", for: indexPath)
        cell.textLabel?.text = viewModel.title(at: indexPath)
        if viewModel.hasSearchResult() {
            cell.accessoryView = UIImageView(image: UIImage(named: "add"))
        } else {
            cell.accessoryView = nil
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard viewModel.hasSearchResult() else { return }
        viewModel.tapped(at: indexPath)
        dismiss(animated: true, completion: nil)
    }
        
}
