//
//  ViewController.swift
//  Project2
//
//  Created by Rio Michelini on 07/12/2020.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var button1: UIButton!
	@IBOutlet var button2: UIButton!
	@IBOutlet var button3: UIButton!
	
	var countries = [String]()
	var questionsAsked = 0
	var score = 0
	var correctAnswer = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		countries += ["estonia", "france", "germany", "ireland", "italy",
					  "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
		
		button1.layer.borderWidth = 2
		button2.layer.borderWidth = 2
		button3.layer.borderWidth = 2
		
		button1.layer.borderColor = UIColor.lightGray.cgColor
		button2.layer.borderColor = UIColor.lightGray.cgColor
		button3.layer.borderColor = UIColor.lightGray.cgColor
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showScore))
		
		askQuestion()
	}

	func askQuestion(action: UIAlertAction! = nil) {
		
		countries.shuffle()
		correctAnswer = Int.random(in: 0...2)
		
		button1.setImage(UIImage(named: countries[0]), for: .normal)
		button2.setImage(UIImage(named: countries[1]), for: .normal)
		button3.setImage(UIImage(named: countries[2]), for: .normal)
		
		questionsAsked += 1

		title = "Country: \(countries[correctAnswer].uppercased()) | Score: \(score)"
		
	}
	
	@IBAction func buttonTapped(_ sender: UIButton) {
		var title: String
		var ac: UIAlertController
		var final: UIAlertController
		
		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [],
			   animations: {
				sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
				sender.transform = .identity
	   }) { finished in
			  sender.isHidden = false
		  }
		
		if questionsAsked <= 10 {
			if sender.tag == correctAnswer {
				title = "Correct"
				score += 1
				ac = UIAlertController(title: title, message: "You get a point! Score +1", preferredStyle: .alert)
				
			} else {
				title = "Wrong"
				score -= 1
				ac = UIAlertController(title: title, message: "Wrong! That was the flag for \(countries[sender.tag].uppercased()), Score -1", preferredStyle: .alert)
			}
			
			ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
			
			present(ac, animated: true)
		} else {
			title = "Final Score"
			final = UIAlertController(title: title, message: "You got \(score). Play again!", preferredStyle: .alert)
			questionsAsked = 0
			score = 0
			final.addAction(UIAlertAction(title: "Play again", style: .default, handler: askQuestion))
			present(final, animated: true)
		}
	}
	
	@objc func showScore() {
		let vc = UIActivityViewController(activityItems: ["Your score was \(score)! Come play flag game again!"], applicationActivities: [])
			vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
			present(vc, animated: true)
	}
	
}

