//
//  ViewController.swift
//  Project12
//
//  Created by Rio Michelini on 29/12/2020.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let defaults = UserDefaults.standard
		
		defaults.set(25, forKey: "Age")
		defaults.set(true, forKey: "FaceID")
		defaults.set(CGFloat.pi, forKey: "Pi")
		
		defaults.set("Rio Michelini", forKey: "Name")
		defaults.set(Date(), forKey: "LastRun")
		
		let array = ["Hello", "World"]
		defaults.set(array, forKey: "SavedArray")
		
		let savedInt = defaults.integer(forKey: "Age")
		let savedBool = defaults.bool(forKey: "FaceID")
		
		let savedArray = defaults.object(forKey: "SavedArray") as? [String] ?? [String]()
		
	}


}

