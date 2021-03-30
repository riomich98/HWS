//
//  ActionViewController.swift
//  Extension
//
//  Created by Rio Michelini on 13/01/2021.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

	@IBOutlet var script: UITextView!
	
	var pageTitle = ""
	var pageURL = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showExamples))
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
		notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		
		if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
			if let itemProvider = inputItem.attachments?.first {
				itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
					guard let itemDictionary = dict as? NSDictionary else { return }
					guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
					
					self?.pageTitle = javaScriptValues["title"] as? String ?? ""
					self?.pageURL = javaScriptValues["URL"] as? String ?? ""
					
					DispatchQueue.main.async {
						self?.title = self?.pageTitle
						let defaults = UserDefaults.standard
						
						if let savedPageURL = defaults.value(forKey: "pageURL") as? String {
							if self?.pageURL == savedPageURL {
								if let savedJavaScript = defaults.value(forKey: "pageScript") as? String {
									self?.script.text = savedJavaScript
								}
							}
						}
					}
				}
			}
		}
    }

    @IBAction func done() {
		save()
		let item = NSExtensionItem()
		let argument: NSDictionary = ["customJavaScript": script.text ?? "alert(\"default\")"]
		let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
		let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
		item.attachments = [customJavaScript]
		extensionContext?.completeRequest(returningItems: [item])
    }
	
	@objc func showExamples() {
		let ac = UIAlertController(title: "Example", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "alert(document.title)", style: .default, handler: example))
		ac.addAction(UIAlertAction(title: "create new div", style: .default, handler: example))
		ac.addAction(UIAlertAction(title: "change background", style: .default, handler: example))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(ac, animated: true)
	}
	
	func example(_ action: UIAlertAction) {
		
		switch action.title {
			case "alert(document.title)":
				script.text = action.title
			case "create new div":
				script.text = """
					var tag = document.createElement("p");
					var text = document.createTextNode("This is a JavaScript injection");
					tag.appendChild(text);
					document.querySelector('body').appendChild(tag);
					"""
			case "change background":
				script.text = "document.body.style.backgroundColor = \"red\";"
			default:
				script.text = "alert(default)"
		}
	}
	
	@objc func adjustForKeyboard(notification: Notification) {
		guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
		let keyboardScreenEndFrame = keyboardValue.cgRectValue
		let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
		
		if notification.name == UIResponder.keyboardWillHideNotification {
			script.contentInset = .zero
		} else {
			script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
		}
		
		script.scrollIndicatorInsets = script.contentInset
		
		script.scrollRangeToVisible(script.selectedRange)
	}
	
	func save() {
		let defaults = UserDefaults.standard
		defaults.setValue(pageURL, forKey: "pageURL")
		defaults.setValue(script.text, forKey: "pageScript")
	}

}
