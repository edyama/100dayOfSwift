//
//  ViewController.swift
//  Challenge2
//
//  Created by Ed Yama on 16/07/21.
//

import UIKit

class ViewController: UITableViewController {

    var shopList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(newList))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTextField))
        
        title = "Shop List"
        
        newList()
        print(shopList)
    }
    
    @objc func newList() {
        shopList.removeAll()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shopList[indexPath.row]
        return cell
    }
    
    @objc func addTextField() {
        
        let ac = UIAlertController(title: "Welcome", message: "Please, insert shop item", preferredStyle: .alert)
        ac.addTextField()
        
        let insertItem = UIAlertAction(title: "Insert", style: .default) {
            [weak self, weak ac] _ in
            guard let item = ac?.textFields?[0].text else { return }
            self?.insert(item)
        }
        
        ac.addAction(insertItem)
        present(ac, animated: true)
    }
    
    func insert(_ item: String) {
        let lowerItem = item.lowercased()
        
        let errorTitle: String
        let errorMessage: String
        
        if isOriginal(item: lowerItem) {
            if isReal(item: lowerItem) {
                shopList.insert(lowerItem, at: 0)
                
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
                
                return
            } else {
                errorTitle = "Word not recognize"
                errorMessage = "You can't just make them up, you know!"
            }
        } else {
            errorTitle = "Item already used."
            errorMessage = "Please, add another item."
        }
        
        showErrorMessage(errorTitle, errorMessage)
    }
    
    func isOriginal(item: String) -> Bool {
        return !shopList.contains(item)
    }
    
    func isReal(item: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: item.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: item, range: range, startingAt: 0, wrap: false, language: "en")
        if mispelledRange.location == NSNotFound && item.count >= 3 {
            return true
        } else {
            return false
        }
    }
    
    func showErrorMessage(_ errorTitle: String, _ errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

