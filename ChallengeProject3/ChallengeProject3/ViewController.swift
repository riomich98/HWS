//
//  ViewController.swift
//  ChallengeProject3
//
//  Created by Rio Michelini on 13/12/2020.
//

import UIKit

class ViewController: UIViewController {
	
	var inputButton = UIButton()
	var livesLabel: UILabel!
	var levelLabel: UILabel!
	var scoreLabel: UILabel!
	var usedCharactersLabel: UILabel!
	var currentWord = UITextField()
	var hangmanView = UIImageView()
	var hangmanImages = [String]()
	
	var usedLetters = [String]()
	var promptWord: String = ""
	var word: String = ""
	var level: Int = 1
	
	var character: Character = "?" {
		didSet {
			usedCharactersLabel.text = "Letters Used: \(character)"
		}
	}
	
	var lives = 6 {
		didSet {
			livesLabel.text = "Lives: \(lives) / 6"
		}
	}
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	override func loadView() {
		view = UIView()
		view.backgroundColor = .systemBackground
		
		livesLabel = UILabel()
		livesLabel.translatesAutoresizingMaskIntoConstraints = false
		livesLabel.textAlignment = .right
		livesLabel.text = "Lives: 0 / 6"
		view.addSubview(livesLabel)
		
		levelLabel = UILabel()
		levelLabel.translatesAutoresizingMaskIntoConstraints = false
		levelLabel.textAlignment = .right
		levelLabel.text = "Level: 1"
		view.addSubview(levelLabel)
		
		scoreLabel = UILabel()
		scoreLabel.translatesAutoresizingMaskIntoConstraints = false
		scoreLabel.textAlignment = .right
		scoreLabel.text = "Score: 0"
		view.addSubview(scoreLabel)
		
		usedCharactersLabel = UILabel()
		usedCharactersLabel.translatesAutoresizingMaskIntoConstraints = false
		usedCharactersLabel.textAlignment = .right
		usedCharactersLabel.text = "Letters Used: "
		view.addSubview(usedCharactersLabel)
		
		currentWord = UITextField()
		currentWord.translatesAutoresizingMaskIntoConstraints = false
		currentWord.placeholder = "???"
		currentWord.textAlignment = .center
		currentWord.font = UIFont.systemFont(ofSize: 34)
		currentWord.isUserInteractionEnabled = false
		view.addSubview(currentWord)
		
		inputButton = UIButton(type: .system)
		inputButton.translatesAutoresizingMaskIntoConstraints = false
		inputButton.setTitle("Guess", for: .normal)
		inputButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
		inputButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
		view.addSubview(inputButton)
		
		hangmanView = UIImageView(image: UIImage(named: "hangman6.jpg"))
		hangmanView.translatesAutoresizingMaskIntoConstraints = false
		hangmanView.layer.cornerRadius = 5
		hangmanView.layer.masksToBounds = true
		hangmanView.sizeToFit()
		view.addSubview(hangmanView)
		hangmanView.center = view.center
		view.bringSubviewToFront(hangmanView)
		
		NSLayoutConstraint.activate([levelLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
			levelLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			
			livesLabel.topAnchor.constraint(equalTo: levelLabel.bottomAnchor, constant: 10),
			livesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			
			scoreLabel.topAnchor.constraint(equalTo: livesLabel.bottomAnchor, constant: 10),
			scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			
			usedCharactersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
				usedCharactersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
		
				inputButton.topAnchor.constraint(equalTo: currentWord.bottomAnchor, constant: 40),
			inputButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			inputButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			
			currentWord.topAnchor.constraint(equalTo: hangmanView.bottomAnchor, constant: 5),
				currentWord.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
				currentWord.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
									
			hangmanView.widthAnchor.constraint(equalToConstant: 400),
			hangmanView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
			hangmanView.heightAnchor.constraint(equalToConstant: 400),
			hangmanView.topAnchor.constraint(equalTo: usedCharactersLabel.topAnchor, constant: 10)])
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.navigationItem.title = "Hangman"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restart))
		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)
		for item in items {
			if item.hasPrefix("hangman") {
				hangmanImages.append(item)
			}
		}
		hangmanImages.sort()
		loadLevel()
	}
	
	@objc func submitTapped(_ sender: UIButton) {
		print(promptWord)
		let ac = UIAlertController(title: "Guess a letter", message: nil, preferredStyle: .alert)
			ac.addTextField()

			let submitAction = UIAlertAction(title: "Guess", style: .default) { [weak self, weak ac] action in
				guard let answer = ac?.textFields?[0].text else { return }
				let allowedCharacters = CharacterSet.letters
				let characterSet = CharacterSet(charactersIn: answer)
				if answer != "" {
					if !self!.usedLetters.contains(answer) {
						if allowedCharacters.isSuperset(of: characterSet) {
							if answer.count > 1 {
								return
							} else {
								self?.usedLetters.append(answer)
								self?.checkAnswer(Character(answer))
							}
						} else {
							self?.showErrorMessage(title: "Not Recognised", message: "You must enter a single character.")
						}
					} else {
						self?.showErrorMessage(title: "Character Already Entered", message: "You cannot reuse characters.")
					}
				} else {
					self?.showErrorMessage(title: "No Character Entered", message: "You must enter a single character.")
				}
			}
			ac.addAction(submitAction)
			present(ac, animated: true)
	}
	
	func checkAnswer(_ char: Character) {
		promptWord = ""
		DispatchQueue.main.async {
			self.usedCharactersLabel.text = "Letters used: \(self.usedLetters.joined(separator: " "))"
		}
		for letter in String(word) {
			if word.contains(char) {
				if usedLetters.contains(String(letter)) {
					promptWord.append(letter)
					if promptWord == word {
						let ac = UIAlertController(title: "Well Done!", message: "Ready for the next level?", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
						present(ac, animated: true)
					}
				} else {
					promptWord += "_ "
				}
			} else {
				if lives <= 0 {
					DispatchQueue.main.async {
						self.hangmanView.image = UIImage(named: self.hangmanImages[self.lives])
						let ac = UIAlertController(title: "You Lose!", message: "Want to play again?", preferredStyle: .alert)
						ac.addAction(UIAlertAction(title: "Sure!", style: .default, handler: self.restart))
						self.present(ac, animated: true)
					}
				} else {
					score -= 1
					lives -= 1
					DispatchQueue.main.async {
						self.hangmanView.image = UIImage(named: self.hangmanImages[self.lives])
					}
				}
				break
			}
			currentWord.text = "\(self.promptWord)"
		}
		if word.contains(char) {
			if usedLetters.contains(String(char)) {
					score += 1
			} else {
				score -= 1
				lives -= 1
			}

		}
	}
	
	@objc func loadLevel() {
		// reset all the scores and arrays
		usedLetters.removeAll()
		promptWord = ""
		word = ""
		usedCharactersLabel.text = "Letters Used: "
		lives = 6
		hangmanView.image = UIImage(named: hangmanImages[lives])
		DispatchQueue.global(qos: .background).async {
			if let wordsFile = Bundle.main.url(forResource: "words", withExtension: "txt") {
				if let wordContents = try? String(contentsOf: wordsFile) {
					var words = wordContents.components(separatedBy: "\n")
					words.shuffle()
					self.word = words[0]
					print(self.word)
					DispatchQueue.main.async {
						for _ in String(self.word) {
								self.promptWord += "_ "
							}
						self.currentWord.text = "\(self.promptWord)"
						self.levelLabel.text = "Level: \(self.level)"
					}
				}
			}
		}
	}
	
	func levelUp(action: UIAlertAction) {
		level += 1
		loadLevel()
	}
	
	@objc func restart(action: UIAlertAction) {
		level = 1
		loadLevel()
	}
	
	func showErrorMessage(title: String, message: String) {
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Okay", style: .default))
		present(ac, animated: true)
	}
}

