//
//  WebViewController.swift
//  Project16
//
//  Created by Rio Michelini on 09/01/2021.
//
import WebKit
import UIKit

class WebViewController: UIViewController, WKNavigationDelegate {
	
	var webView: WKWebView!
	var selectedCapital: String = ""

	override func loadView() {
		webView = WKWebView()
		webView.navigationDelegate = self
		view = webView
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let url = URL(string: "https://wikipedia.org/wiki/" + selectedCapital)!
		webView.load(URLRequest(url: url))
		webView.allowsBackForwardNavigationGestures = true
    }
    

}
