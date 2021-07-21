//
//  ViewController.swift
//  Challenge3
//
//  Created by Ed Yama on 21/07/21.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    var word = ""
    var allWords = [String]()
    var usedLetters = [String]()
    var promptWord = ""
    var score = 0
    var wrongAnswers = 0
    
    @IBOutlet weak var wordLabel: UILabel!
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetWord))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLetter))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        } else if allWords.isEmpty {
            allWords = ["SILWORM"]
        }
        
        word = allWords.randomElement()?.uppercased() ?? "SILWORM"
        performSelector(onMainThread: #selector(startWord), with: nil, waitUntilDone: false)
    }
    
    @objc func startWord() {
        promptWord = ""
        
        title = "Score: \(score)"
        
        for letter in word {
            let strLetter = String(letter)

            if usedLetters.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        wordLabel.text = promptWord
    }

    @objc func addLetter() {
        let ac = UIAlertController(title: "Please", message: "Digit some letters here", preferredStyle: .alert)
        ac.addTextField()
        
        let letterInput = UIAlertAction(title: "Click here!", style: .default) {
            [weak self, weak ac] _ in
            guard let letter = ac?.textFields?[0].text else { return }
            self?.submit(letter)
        }
        
        ac.addAction(letterInput)
        present(ac, animated: true)
    }
    
    @objc func resetWord() {
        usedLetters.removeAll()
        word = allWords.randomElement()?.uppercased() ?? "SILWORM"
        performSelector(onMainThread: #selector(startWord), with: nil, waitUntilDone: false)
    }
    
    func submit(_ letter: String) {
        if letter.count < 2 {
            if word.contains(letter.uppercased()) {
                let ac = UIAlertController(title: "Correct", message: "This letter exists in this word!", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                
                score += 1
            } else {
                wrongAnswers += 1
                
                let ac = UIAlertController(title: "Error", message: "This letter does not exist! Wrong answers: \(wrongAnswers)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            
            usedLetters.append(letter.uppercased())
            performSelector(onMainThread: #selector(startWord), with: nil, waitUntilDone: false)
        } else {
            let ac = UIAlertController(title: "Letter denied!", message: "Plese, digit only a letter!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
}

