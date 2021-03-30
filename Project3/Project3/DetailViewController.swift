//
//  DetailViewController.swift
//  Project1
//
//  Created by Rio Michelini on 06/12/2020.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	var selectedImage: String?
	var selectedImageNumber = 0
	var totalImages = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let imageTitle = "Picture \(selectedImageNumber) of \(totalImages)"
		title = imageTitle
		navigationItem.largeTitleDisplayMode = .never
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

		// Do any additional setup after loading the view.
		if let imageToLoad = selectedImage {
			imageView.image = UIImage(named: imageToLoad)
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

	@objc func shareTapped() {
		guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
			print("No image found")
			return
		}
		let vc = UIActivityViewController(activityItems: [image, selectedImage ?? "Picture"], applicationActivities: [])
		vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
		present(vc, animated: true)
	}

}
