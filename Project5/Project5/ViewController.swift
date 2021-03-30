//
//  ViewController.swift
//  Project5
//
//  Created by Rio Michelini on 08/12/2020.
//

import UIKit

class ViewController: UITableViewController {
	
	var allWords = [String]()
	var usedWords = [String]()
	var currentWord = ""

	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startNewGame))
		
		// Do any additional setup after loading the view.
		if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
			if let startWords = try? String(contentsOf: startWordsURL) {
				allWords = startWords.components(separatedBy: "\n")
			}
		}
		
		if allWords.isEmpty {
			allWords = ["silkworm"]
		}
		let defaults = UserDefaults.standard
		
		if let savedWordGameCurrentWord = defaults.value(forKey: "wordGameCurrentWord") as? String {
			currentWord = savedWordGameCurrentWord
		} else {
			startNewGame()
		}
		
		if let savedWordGameUsedWords = defaults.value(forKey: "wordGameUsedWords") as? [String] {
			usedWords = savedWordGameUsedWords
		} else {
			startNewGame()
		}
		
		startGame()
		
	}
	
	@objc func startGame() {
		title = currentWord
		tableView.reloadData()
	}
	
	@objc func startNewGame() {
		title = allWords.randomElement()
		currentWord = title ?? "silkworm"
		usedWords.removeAll(keepingCapacity: true)
		save()
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return usedWords.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
		cell.textLabel?.text = usedWords[indexPath.row]
		return cell
	}
	
	@objc func promptForAnswer() {
		let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
			guard let answer = ac?.textFields?[0].text else { return }
			self?.submit(answer)
		}
		
		ac.addAction(submitAction)
		present(ac, animated: true)
	}
	
	func submit(_ answer: String) {
		let lowerAnswer = answer.lowercased()
		if isSameWord(word: lowerAnswer) {
			if isPossible(word: lowerAnswer) {
				if isOriginal(word: lowerAnswer) {
					if isReal(word: lowerAnswer) {
						usedWords.insert(lowerAnswer, at: 0)
						let indexPath = IndexPath(row: 0, section: 0)
						tableView.insertRows(at: [indexPath], with: .automatic)
						save()
						return
					} else {
						showErrorMessage(errorTitle: "'\(lowerAnswer)' Not Recognised", errorMessage: "This word is not playable.")
					}
				} else {
					showErrorMessage(errorTitle: "'\(lowerAnswer)' Already Used", errorMessage: "This word has already been played.")
				}
			} else {
				showErrorMessage(errorTitle: "'\(lowerAnswer)' Not Possible", errorMessage: "You cannot spell that word from '\(title!.lowercased())'")
			}
		} else {
			showErrorMessage(errorTitle: "'\(lowerAnswer)' is \(title!.lowercased())", errorMessage: "You have used the starting word.")
		}
	}
	
	func isSameWord(word: String) -> Bool {
		if word == title?.lowercased() {
			return false
		} else {
			return true
		}
	}
	
	func isPossible(word: String) -> Bool {
		guard var tempWord = title?.lowercased() else {
			return false
		}
		for letter in word {
			if let position = tempWord.firstIndex(of: letter) {
				tempWord.remove(at: position)
			} else {
				return false
			}
		}
		return true
	}
	
	func isOriginal(word: String) -> Bool {
		return !usedWords.contains(word)
	}

	func isReal(word: String) -> Bool {
		let checker = UITextChecker()
		let range = NSRange(location: 0, length: word.utf16.count)
		let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
		if word.count < 3 {
			return false
		}
		return misspelledRange.location == NSNotFound
	}

	func showErrorMessage(errorTitle title: String, errorMessage message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Okay", style: .default))
		present(ac, animated: true)
	}
	
	func save() {
		let defaults = UserDefaults.standard
		defaults.setValue(usedWords, forKey: "wordGameUsedWords")
		defaults.setValue(currentWord, forKey: "wordGameCurrentWord")
	}

}

