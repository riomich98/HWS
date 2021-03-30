//
//  ViewController.swift
//  ChallengeProject5
//
//  Created by Rio Michelini on 08/01/2021.
//

import UIKit

class ViewController: UITableViewController {
	
	var countries: [Country] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		title = "Countries"
		
		navigationController?.navigationBar.prefersLargeTitles = true
		
		DispatchQueue.global(qos: .background).async {
			// get the Data from the bundle
			let url = Bundle.main.url(forResource: "countries", withExtension: "json")!
			let data = try! Data(contentsOf: url)
			let decoder = JSONDecoder()
			if let jsonCountries = try? decoder.decode([Country].self, from: data) {
				for country in jsonCountries {
					self.countries.append(country)
				}
				DispatchQueue.main.async {
					self.tableView.reloadData()
				}
			}
		}
		
		print(countries)
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = "\(countries[indexPath.row].country)"
		cell.textLabel?.numberOfLines = 0
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewController(withIdentifier: "DetailView") as? DetailViewController
		vc?.selectedCountry = countries[indexPath.row]
		navigationController?.pushViewController(vc!, animated: true)
	}

}

