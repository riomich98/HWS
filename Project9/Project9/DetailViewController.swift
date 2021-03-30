//
//  DetailViewController.swift
//  Project9
//
//  Created by Rio Michelini on 10/12/2020.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
	
	var webView: WKWebView!
	var detailItem: Petition?
	
	override func loadView() {
		webView = WKWebView()
		view = webView
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		guard let detailItem = detailItem else { return }
		
		let html = """
		<html>
		<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<style> body { font-size: 125%; font-family: Helvetica; } </style>
		</head>
		<body>
		<h4>\(detailItem.title)</h4>
		<h5>\(detailItem.signatureCount)</h5>
		<p>\(detailItem.body)</p>
		</body>
		</html>
		"""
		
		webView.loadHTMLString(html, baseURL: nil)
    }

}
