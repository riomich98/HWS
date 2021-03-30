//
//  ViewController.swift
//  ChallengeProject23
//
//  Created by Rio Michelini on 07/12/2020.
//

import UIKit

class ViewController: UITableViewController {
	
	var countries = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let fm = FileManager.default
		let path = Bundle.main.resourcePath!
		let items = try! fm.contentsOfDirectory(atPath: path)
		
		for item in items {
			if item.hasSuffix(".png") {
				// flag to load
				countries.append(item)
			}
		}
		countries.sort()
		
		title = "FlagView"
		navigationController?.navigationBar.prefersLargeTitles = true
		
	}


	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return countries.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
		cell.textLabel?.text = (countries[indexPath.row] as NSString).deletingPathExtension
		let image = UIImage(named: countries[indexPath.row])
		cell.imageView?.image = image
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			// 2: success! Set its selectedImage property
			vc.selectedFlag = countries[indexPath.row]

			// 3: now push it onto the navigation controller
			navigationController?.pushViewController(vc, animated: true)
		}
	}

}

