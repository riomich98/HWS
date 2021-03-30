//
//  ViewController.swift
//  Project18
//
//  Created by Rio Michelini on 10/01/2021.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
//		// Print Debugging
//
//		print("I'm inside the viewDidLoad() method.")
//		print(1,2,3,4,5, separator: "-", terminator: "")
//
//		// Assert Debugging
//		assert(1 == 1, "Math Failure!")
//		assert(1 < 2, "Math Failure!")
		
		for i in 1...100 {
			print("Got number \(i)")
		}
		
	}


}

