//
//  ViewController.swift
//  Project7
//
//  Created by Rio Michelini on 10/12/2020.
//

import UIKit

class ViewController: UITableViewController {
	
	var petitions = [Petition]()
	var originalPetitions = [Petition]()
	var filteredPetitions = [Petition]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let urlString: String
			
		if navigationController?.tabBarItem.tag == 0 {
			urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
		} else {
			urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
		}
		
		navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped)), UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(resetTapped))]
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
		
		DispatchQueue.global(qos: .background).async {
			if let url = URL(string: urlString) {
				if let data = try? Data(contentsOf: url) {
					self.parse(json: data)
					return
				}
			}
			self.showError()
		}
	}
	
	func showError() {
		let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; Please check your connection and try again.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	func parse(json: Data) {
		let decoder = JSONDecoder()
		
		if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
			originalPetitions = jsonPetitions.results
			petitions = originalPetitions
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return petitions.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let petition = petitions[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = petition.title
		cell.detailTextLabel?.text = petition.body
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let vc = DetailViewController()
		vc.detailItem = petitions[indexPath.row]
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func shareTapped() {
		let ac = UIAlertController(title: "Credits", message: "This data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
	
	@objc func searchTapped() {
		let ac = UIAlertController(title: "Filter by", message: nil, preferredStyle: .alert)
		ac.addTextField()
		let search = UIAlertAction(title: "Submit", style: .default) { [weak ac] _ in
			guard let filterVar = ac?.textFields?[0].text else { return }
			DispatchQueue.global(qos: .background).async {
				for petition in self.petitions {
					if petition.body.contains(filterVar) || petition.title.contains(filterVar) {
						self.filteredPetitions.append(petition)
					}
				}
			}
			DispatchQueue.main.async {
				self.petitions = self.filteredPetitions
				self.tableView.reloadData()
			}
		}
		
		ac.addAction(search)
		present(ac, animated: true)
	}
	
	@objc func resetTapped() {
		petitions.removeAll(keepingCapacity: true)
		filteredPetitions.removeAll()
		petitions = originalPetitions
		tableView.reloadData()
	}


}

