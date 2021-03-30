//
//  Item.swift
//  ChallengeProject4
//
//  Created by Rio Michelini on 04/01/2021.
//

import UIKit

class Item: NSObject, Codable {
	var filename: String
	var caption: String
	
	init(filename: String, caption: String) {
		self.filename = filename
		self.caption = caption
	}
}

