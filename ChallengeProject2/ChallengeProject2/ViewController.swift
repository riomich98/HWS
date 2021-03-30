//
//  ViewController.swift
//  ChallengeProject2
//
//  Created by Rio Michelini on 09/12/2020.
//

import UIKit

class ViewController: UITableViewController {
	
	var shoppingList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingItem))
		
		navigationItem.leftBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reset)), UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))]
		
		
		
		title = "Shopping List"
		
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return shoppingList.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ListItem", for: indexPath)
		cell.textLabel?.text = shoppingList[indexPath.row]
		return cell
	}
	
	func submit(_ listItem: String) {
		shoppingList.insert(listItem, at: 0)
		
		let indexPath = IndexPath(row: 0, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
		
		return
	}
	
	@objc func addShoppingItem() {
		let ac = UIAlertController(title: "Add Shopping List Item", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
			guard let answer = ac?.textFields?[0].text else { return }
			self?.submit(answer)
		}
		
		ac.addAction(submitAction)
		present(ac, animated: true)
	}
	
	@objc func shareTapped() {
		let list = shoppingList.joined(separator: "\n")
		let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}
	
	@objc func reset() {
		shoppingList.removeAll(keepingCapacity: true)
		tableView.reloadData()
	}
}

