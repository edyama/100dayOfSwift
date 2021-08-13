//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Ed Yama on 28/07/21.
//

import UIKit

class DetailViewController: UITableViewController {

    var detailItem: Country!
    let formatter = NumberFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        formatter.numberStyle = .decimal
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard detailItem != nil else {
            print("Parameters not set")
            navigationController?.popViewController(animated: true)
            return
        }
        
        title = detailItem?.name
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Text", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = buildName()
        case 1:
            cell.textLabel?.text = buildCapital()
        case 2:
            cell.textLabel?.text = buildRegion()
        case 3:
            cell.textLabel?.text = buildSubregion()
        case 4:
            cell.textLabel?.text = buildPopulation()
        case 5:
            cell.textLabel?.text = buildDemonym()
        case 6:
            cell.textLabel?.text = buildArea()
        case 7:
            cell.textLabel?.text = buildGini()
        default:
            return cell
        }
        
        return cell
    }
    
    func buildName() -> String {
        return "Name: \(detailItem.name)"
    }
    
    func buildCapital() -> String {
        return "Capital: \(detailItem.capital)"
    }
    
    func buildRegion() -> String {
        return "Capital: \(detailItem.region)"
    }
    
    func buildSubregion() -> String {
        return "Capital: \(detailItem.subregion)"
    }
    
    func buildDemonym() -> String {
        return "Demonym: \(detailItem.demonym)"
    }
    
    func buildPopulation() -> String {
        if let population = formatter.string(for: detailItem.population) {
            return "Population: \(population)"
        }
        return "Population: unknown"
    }
    
    func buildArea() -> String {
        if let area = formatter.string(for: detailItem.area) {
            return "Area: \(area) km²"
        }
        return "Area: unknown"
    }
    
    func buildGini() -> String {
        if let gini = formatter.string(for: detailItem.gini) {
            return "Gini: \(gini)"
        }
        return "Gini: unknown"
    }
}
