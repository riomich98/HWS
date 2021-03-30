//
//  ViewController.swift
//  Project4
//
//  Created by Rio Michelini on 07/12/2020.
//

import UIKit
import WebKit

class ViewController: UITableViewController {
	
	var websites = ["hackingwithswift.com", "google.com"]

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		title = "WebView"
		navigationController?.navigationBar.prefersLargeTitles = true
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return websites.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Website", for: indexPath)
		cell.textLabel?.text = websites[indexPath.row]
		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// 1: try loading the "Detail" view controller and typecasting it to be WebViewController
		if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
			// 2: success! Set its selectedImage property
			vc.selectedWebsite = websites[indexPath.row]
			vc.websiteArray = websites

			// 3: now push it onto the navigation controller
			navigationController?.pushViewController(vc, animated: true)
		}
	}


}

