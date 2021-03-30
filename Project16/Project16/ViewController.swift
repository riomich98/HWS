//
//  ViewController.swift
//  Project16
//
//  Created by Rio Michelini on 09/01/2021.
//
import MapKit
import WebKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
		let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
		let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
		let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
		let washington = Capital(title: "Washington D.C.", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
		
		mapView.addAnnotations([london, oslo, paris, rome, washington])
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(settingsTapped))
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard annotation is Capital else { return nil }
		
		let identifier = "Capital"
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
		if annotationView == nil {
			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
			annotationView?.canShowCallout = true
			annotationView?.pinTintColor = .systemPurple
			
			let btn = UIButton(type: .detailDisclosure)
			annotationView?.rightCalloutAccessoryView = btn
		} else {
			annotationView?.annotation = annotation
		}
		
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		guard let capital = view.annotation as? Capital else { return }
		// Challenge 3 
//		let placeName = capital.title
//		let placeInfo = capital.info
//		
//		let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
//		ac.addAction(UIAlertAction(title: "OK", style: .default))
//		
//		present(ac, animated: true)
		
		if let vc = storyboard?.instantiateViewController(withIdentifier: "WebView") as? WebViewController {
			navigationController?.pushViewController(vc, animated: true)
			vc.selectedCapital = capital.title!
		}
	}
	
	@objc func settingsTapped() {
		let ac = UIAlertController(title: "Change Map View", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self]_ in
			self?.mapView.mapType = .standard
		}))
		ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self]_ in
			self?.mapView.mapType = .satellite
		}))
		ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { [weak self]_ in
			self?.mapView.mapType = .hybrid
		}))
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		
		present(ac, animated: true)
	}
}

