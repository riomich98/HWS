//
//  DetailViewController.swift
//  ChallengeProject5
//
//  Created by Rio Michelini on 08/01/2021.
//

import UIKit

class DetailViewController: UIViewController {
	
	var selectedCountry: Country?

	@IBOutlet var detailScroll: UIScrollView!
	@IBOutlet var capitalCityLabel: UILabel!
	@IBOutlet var sizeLabel: UILabel!
	@IBOutlet var populationLabel: UILabel!
	@IBOutlet var currencyLabel: UILabel!
	@IBOutlet var gdpLabel: UILabel!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		view.backgroundColor = .systemBackground
		
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
		
		guard let selectedCountry = selectedCountry else { return }
		
		title = selectedCountry.country
		
		capitalCityLabel.text = "Capital City: \(selectedCountry.capitalCity)"
		sizeLabel.text = "Country Size: \(selectedCountry.size) km2"
		populationLabel.text = "Population: \(selectedCountry.population)"
		currencyLabel.text = "Currency: \(selectedCountry.currency)"
		gdpLabel.text = "GDP: $\(selectedCountry.gdp) Trillion"
    }
	
	@objc func shareTapped() {
		
	}

}
