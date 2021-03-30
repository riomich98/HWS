//
//  DetailViewController.swift
//  ChallengeProject4
//
//  Created by Rio Michelini on 04/01/2021.
//

import UIKit

class DetailViewController: UIViewController {
	
	@IBOutlet var imageView: UIImageView!
	var selectedItem: Item?
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		navigationItem.largeTitleDisplayMode = .never

		// Do any additional setup after loading the view.
		if let imageToLoad = selectedItem {
			let path = getDocumentsDirectory().appendingPathComponent(imageToLoad.filename)
			imageView.image = UIImage(contentsOfFile: path.path)
			title = imageToLoad.caption
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		navigationController?.hidesBarsOnTap = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		navigationController?.hidesBarsOnTap = false
	}

}
