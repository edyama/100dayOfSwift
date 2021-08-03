//
//  ViewController.swift
//  Challenge5
//
//  Created by Ed Yama on 28/07/21.
//

import UIKit

class ViewController: UITableViewController {

    // MARK: - Properties
    
    var countries = [Country]()
    var filteredCountries = [Country]()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addTextField))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetCountries))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        
        let urlString = "https://restcountries.eu/rest/v2"
        
        if let url = URL(string: urlString) {
            guard let data = try? Data(contentsOf: url) else { return }
            parse(json: data)
            return
        }

        performSelector(inBackground: #selector(showError), with: nil)
    }
    
    @objc func addTextField() {
        
        let ac = UIAlertController(title: "Search", message: "Please, search country here", preferredStyle: .alert)
        ac.addTextField()
        
        let petitionRequire = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let search = ac?.textFields?[0].text else { return }
            self?.submit(search)
        }
        
        ac.addAction(petitionRequire)
        present(ac, animated: true)
    }
    
    @objc func resetCountries() {
        filteredCountries = countries
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonCountries = try? decoder.decode(Countries.self, from: json) {
            countries = jsonCountries.results
            filteredCountries = countries
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    func submit(_ search: String) {
        filteredCountries = filteredCountries.filter { $0.name.lowercased().contains(search.lowercased()) }
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        let filteredCountry = filteredCountries[indexPath.row]
        
        if filteredCountries.isEmpty {
            cell.textLabel?.text = country.name
            cell.detailTextLabel?.text = country.capital
        } else {
            cell.textLabel?.text = filteredCountry.name
            cell.detailTextLabel?.text = filteredCountry.capital
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

