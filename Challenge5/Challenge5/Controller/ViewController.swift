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
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
    
    @objc func fetchJSON() {
        let urlString = "https://restcountries.eu/rest/v2/all?fields=name;capital;population;area;gini"
        
        if let url = URL(string: urlString) {
            guard let data = try? Data(contentsOf: url) else { return }
            guard let jsonCountries = try? JSONDecoder().decode([Country].self, from: data) else { return }
            countries = jsonCountries
        } else {
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
        
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = country.capital
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = countries[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}


