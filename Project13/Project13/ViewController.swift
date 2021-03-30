//
//  ViewController.swift
//  Project13
//
//  Created by Rio Michelini on 06/01/2021.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet var imageView: UIImageView!
	@IBOutlet var intensity: UISlider!
	@IBOutlet var radius: UISlider!
	@IBOutlet var scale: UISlider!
	@IBOutlet var changeFilterButton: UIButton!
	@IBOutlet var saveButton: UIButton!
	var currentImage: UIImage!
	
	var context: CIContext!
	var currentFilter: CIFilter!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		title = "InstaFilter"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
		
		context = CIContext()
		currentFilter = CIFilter(name: "CISepiaTone")
		
		scale.isEnabled = false
		intensity.isEnabled = false
		radius.isEnabled = false
		changeFilterButton.isEnabled = false
		saveButton.isEnabled = false
	}
	
	@objc func importPicture() {
		let picker = UIImagePickerController()
		picker.allowsEditing = true
		picker.delegate = self
		picker.sourceType = .photoLibrary
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		}
		present(picker, animated: true)
		intensity.isEnabled = true
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		dismiss(animated: true)
		currentImage = image
		
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		imageView.alpha = 0
		applyProcessing()
		
		changeFilterButton.isEnabled = true
		changeFilterButton.setTitle("CISepiaTone", for: .normal)
		saveButton.isEnabled = true
	}

	@IBAction func changeFilter(_ sender: UIButton) {
		let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		if let popoverController = ac.popoverPresentationController {
			popoverController.sourceView = sender
			popoverController.sourceRect = sender.bounds
		}
		
		present(ac, animated: true)
	}
	
	func setFilter(action: UIAlertAction) {
		guard currentImage != nil else { return }
		guard let actionTitle = action.title else { return }
		currentFilter = CIFilter(name: actionTitle)
		let beginImage = CIImage(image: currentImage)
		currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
		
		intensity.setValue(0.5, animated: false)
		radius.setValue(0.5, animated: false)
		scale.setValue(0.5, animated: false)
		intensity.isEnabled = false
		radius.isEnabled = false
		scale.isEnabled = false
		
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) {
			intensity.isEnabled = true
		}
		
		if inputKeys.contains(kCIInputRadiusKey) {
			radius.isEnabled = true
		}
		
		if inputKeys.contains(kCIInputScaleKey) {
			scale.isEnabled = true
		}
		changeFilterButton.setTitle("\(currentFilter.name)", for: .normal)
		applyProcessing()
	}
	
	@IBAction func save(_ sender: Any) {
		guard let image = imageView.image else {
			let ac = UIAlertController(title: "Save Error", message: "You do not have an image selected.", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
			return
		}
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
	}
	
	@IBAction func intensityChanged(_ sender: Any) {
		applyProcessing()
	}
	
	@IBAction func radiusChanged(_ sender: Any) {
		applyProcessing()
	}
	
	@IBAction func scaleChanged(_ sender: Any) {
		applyProcessing()
	}
	
	
	func applyProcessing() {
		let inputKeys = currentFilter.inputKeys
		
		if inputKeys.contains(kCIInputIntensityKey) {
			currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
		}
		
		if inputKeys.contains(kCIInputRadiusKey) {
			currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey)
		}
		
		if inputKeys.contains(kCIInputScaleKey) {
			currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
		}
		
		if inputKeys.contains(kCIInputCenterKey) {
			currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
		}
		
		guard let outputImage = currentFilter.outputImage else { return }
		
		if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
			let processedImage = UIImage(cgImage: cgImage)
			imageView.image = processedImage
			UIView.animate(withDuration: 1, delay: 0, options: []) {
				self.imageView.alpha = 1
			}

		}
		
		[intensity, radius, scale].forEach { $0?.setNeedsLayout(); $0?.layoutIfNeeded() }
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		} else {
			let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photo library!", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "OK", style: .default))
			present(ac, animated: true)
		}
	}
}

