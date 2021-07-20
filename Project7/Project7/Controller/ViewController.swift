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
        
        let filter = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(addTextField))
        let reset = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetPetitions))
        
        navigationItem.leftBarButtonItems = [filter, reset]
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(alertWhiteHouse))
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    @objc func fetchJSON() {
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        
        if let url = URL(string: urlString) {
            guard let data = try? Data(contentsOf: url) else { return }
            parse(json: data)
            return
        }

        performSelector(inBackground: #selector(showError), with: nil)
    }
    
    @objc func addTextField() {
        
        let ac = UIAlertController(title: "Dear, citizen", message: "Please, search petition here", preferredStyle: .alert)
        ac.addTextField()
        
        let petitionRequire = UIAlertAction(title: "Search", style: .default) {
            [weak self, weak ac] _ in
            guard let search = ac?.textFields?[0].text else { return }
            self?.submit(search)
        }
        
        ac.addAction(petitionRequire)
        present(ac, animated: true)
    }
    
    @objc func resetPetitions() {
        filteredPetitions = petitions
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    @objc func alertWhiteHouse() {
        let ac = UIAlertController(title: "Credits", message: "This app is credit to the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Yes, sir", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    func submit(_ search: String) {
        filteredPetitions = filteredPetitions.filter { $0.title.lowercased().contains(search.lowercased()) }
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        let filteredPetition = filteredPetitions[indexPath.row]
        
        if filteredPetitions.isEmpty {
            cell.textLabel?.text = petition.title
            cell.detailTextLabel?.text = petition.body
        } else {
            cell.textLabel?.text = filteredPetition.title
            cell.detailTextLabel?.text = filteredPetition.body
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

