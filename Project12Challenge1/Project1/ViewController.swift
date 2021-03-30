//
//  ViewController.swift
//  Project1
//
//  Created by Rio Michelini on 06/12/2020.
//

import UIKit

class ViewController: UITableViewController {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var subtitleLabel: UILabel!

	var pictures = [String]()
	var pictureDictionary = [String: Int]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		navigationItem.title = "StormViewer"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		
		DispatchQueue.global(qos: .background).async {
			let fm = FileManager.default
			let path = Bundle.main.resourcePath!
			let items = try! fm.contentsOfDirectory(atPath: path)
			
			for item in items {
				if item.hasPrefix("nssl") {
					// this is a picture to load!!
					self.pictures.append(item)
				}
			}
			self.pictures.sort()
		}
		
		let defaults = UserDefaults.standard
		
		if let savedPictureDictionary = defaults.value(forKey: "pictureDictionary") as? [String: Int] {
			pictureDictionary = savedPictureDictionary
		}
		
		tableView.reloadData()
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) as? TableViewCell
		cell?.titleLabel.text = "Picture \(indexPath.row + 1)"
		cell?.subtitleLabel.text = "(Viewed: \(pictureDictionary[pictures[indexPath.row]] ?? 0) times)"
		return cell!
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.selectedImage = pictures[indexPath.row]
			vc.selectedImageNumber = indexPath.row + 1
			vc.totalImages = pictures.count
			var count = pictureDictionary[pictures[indexPath.row]] ?? 0
			count += 1
			pictureDictionary.updateValue(count, forKey: pictures[indexPath.row])
			save()
			tableView.reloadData()
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	@objc func shareTapped() {
		let vc = UIActivityViewController(activityItems: ["Share this app with your friends!"], applicationActivities: [])
		   vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		   present(vc, animated: true)
	}
	
	func save() {
		let defaults = UserDefaults.standard
		defaults.setValue(pictureDictionary, forKey: "pictureDictionary")
	}

}

