//
//  ViewController.swift
//  Project7
//
//  Created by Ed Yama on 19/07/21.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addTextField))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(alertWhiteHouse))
        
        loadingUrl("")
    }

    @objc func addTextField() {
        
        let ac = UIAlertController(title: "Dear, citizen", message: "Please, search petition here", preferredStyle: .alert)
        ac.addTextField()
        
        let petitionRequire = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let search = ac?.textFields?[0].text else { return }
            self?.loadingUrl(search)
        }
        
        ac.addAction(petitionRequire)
        present(ac, animated: true)
    }
    
    @objc func alertWhiteHouse() {
        let ac = UIAlertController(title: "Welcome", message: "To the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes, sir", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func loadingUrl(_ search: String) {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            guard let data = try? Data(contentsOf: url) else { return }
            parse(json: data, "")
            return
        }
    
        showError()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection adn try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func parse(json: Data, _ search: String) {
        let decoder = JSONDecoder()
    
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            if search == "" {
                petitions = jsonPetitions.results
                tableView.reloadData()
            } else {
                for petition in petitions {
                    if petition.title.lowercased().contains(search) {
                        filteredPetitions.append(petition)
                    }
                }
                
                tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

