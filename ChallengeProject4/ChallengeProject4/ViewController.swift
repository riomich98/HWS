//
//  ViewController.swift
//  ChallengeProject4
//
//  Created by Rio Michelini on 01/01/2021.
//

import UIKit

extension UIViewController {
	func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var items = [Item]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		title = "iPicker"
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
		
		let defaults = UserDefaults.standard
		
		if let savedItems = defaults.object(forKey: "items") as? Data {
			let jsonDecoder = JSONDecoder()
			do {
				items = try jsonDecoder.decode([Item].self, from: savedItems)
			} catch {
				print("Failed to load people")
			}
		}
		
		tableView.reloadData()
		
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
		cell.textLabel?.text = items[indexPath.row].caption
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
			vc.selectedItem = items[indexPath.row]
			navigationController?.pushViewController(vc, animated: true)
		}
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			items.remove(at: indexPath.row)
			save()
			tableView.deleteRows(at: [indexPath], with: .fade)
		} else if editingStyle == .insert {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
		}
	}
	
	@objc func addNewItem() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		}
		present(picker, animated: true)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		
		if let jpegData = image.jpegData(compressionQuality: 0.8) {
			try? jpegData.write(to: imagePath)
		}
		
		dismiss(animated: true)

		let ac = UIAlertController(title: "Add Caption", message: nil, preferredStyle: .alert)
		ac.addTextField()

		ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak ac] _ in
			guard let newCaption = ac?.textFields?[0].text else { return }
			let item = Item(filename: imageName, caption: newCaption)
			self?.items.append(item)
			self?.save()
			let indexPath = IndexPath(row: 0, section: 0)
			self?.tableView.insertRows(at: [indexPath], with: .fade)
			self?.tableView.reloadData()
		}))

		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		present(ac, animated: true)

	}
	
	func save() {
		let jsonEncoder = JSONEncoder()
		if let savedData = try? jsonEncoder.encode(items) {
			let defaults = UserDefaults.standard
			defaults.set(savedData, forKey: "items")
		} else {
			print("Failed to save")
		}
	}

}

