//
//  ViewController.swift
//  Project1
//
//  Created by Rio Michelini on 06/12/2020.
//

import UIKit

class ViewController: UICollectionViewController {
	
	var pictures = [String]()

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		navigationItem.title = "StormViewer"
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		
		DispatchQueue.global().async {
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
			
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}

	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return pictures.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
			// we failed to get a PersonCell – bail out!
			fatalError("Unable to dequeue PictureCell.")
		}
		cell.imageView.image = UIImage(named: pictures[indexPath.row])
		return cell
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

