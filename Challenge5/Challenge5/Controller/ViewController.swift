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
        
        title = "Countries facts"
        
        fetchJSON()
    }
    
    func fetchJSON() {
        let urlString = "https://restcountries.eu/rest/v2/all"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let data = try Data(contentsOf: url)
            let decode = JSONDecoder()
            let jsonCountries = try decode.decode([Country].self, from: data)
            countries = jsonCountries
        } catch {
            print(error)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.detailItem = countries[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
