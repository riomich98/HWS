//
//  DetailViewController.swift
//  ChallengeProject23
//
//  Created by Rio Michelini on 07/12/2020.
//

import UIKit

class DetailViewController: UIViewController {

	var selectedFlag: String?
	
	@IBOutlet var ImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		if let imageToLoad = selectedFlag {
			ImageView.image = UIImage(named: imageToLoad)
		}
		
		view.backgroundColor = UIColor.lightGray
		
		title = (selectedFlag! as NSString).deletingPathExtension
		
		navigationItem.largeTitleDisplayMode = .never
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
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
		let vc = UIActivityViewController(activityItems: [selectedFlag!], applicationActivities: [])
			vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
			present(vc, animated: true)
	}
}
