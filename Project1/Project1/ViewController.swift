//
//  ViewController.swift
//  Project1
//
//  Created by Rio Michelini on 06/12/2020.
//

import UIKit

class ViewController: UITableViewController {
	
	var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		navigationItem.title = "StormViewer"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		
		DispatchQueue.global().async {
			let fm = FileManager.default
			let path = Bundle.main.resourcePath!
			let items = try! fm.contentsOfDirectory(atPath: path)
			
			DispatchQueue.main.async {
				for item in items {
					if item.hasPrefix("nssl") {
						// this is a picture to load!!
						self.pictures.append(item)
					}
				}
				self.pictures.sort()
				self.tableView.reloadData()
			}
		}

	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
		cell.textLabel?.text = "Picture \(indexPath.row + 1)"
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.selectedImage = pictures[indexPath.row]
			vc.selectedImageNumber = indexPath.row + 1
			vc.totalImages = pictures.count
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	@objc func shareTapped() {
		let vc = UIActivityViewController(activityItems: ["Share this app with your friends!"], applicationActivities: [])
		   vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		   present(vc, animated: true)
	}

}

