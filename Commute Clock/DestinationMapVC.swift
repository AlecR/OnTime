//
//  DestinationMapVC.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/16/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

enum TransportationType: String {
    case Car
    case Walking
    case Transit
}

protocol DestinationMapVCDelegate {
    func acceptDestinationData(destination: GMSPlace!, transportation: TransportationType)
}

class DestinationMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, GMSAutocompleteResultsViewControllerDelegate {
	
	/* Outlets */
	@IBOutlet weak var mapView: MKMapView!

	
	@IBOutlet weak var carImage: UIImageView!
	@IBOutlet weak var walkingImage: UIImageView!
	@IBOutlet weak var transitImage: UIImageView!
	
	@IBOutlet weak var destinationLabel: UILabel!
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var transportTypeLabel: UILabel!
	
	
	/* Variables */
    
    var delegate: DestinationMapVCDelegate?
    var data: AnyObject?
	
	var transportImages: [UIImageView] = []
	
	var resultSearchController: UISearchController? = nil
	var autocompleteController: GMSAutocompleteResultsViewController!
	
	let locationManager = CLLocationManager()
	
	var destinationString: String! = "Not Selected" {
		didSet {
			destinationLabel.text = destinationString
		}
	}

	var addressString: String! = "" {
		didSet {
			addressLabel.text = addressString
		}
	}
	
	var selectedDestination: GMSPlace?
    var selectedTransportation: TransportationType = .Car
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		transportImages = [carImage, walkingImage, transitImage]
		
		mapView.delegate = self
		
		autocompleteController = GMSAutocompleteResultsViewController()
		autocompleteController.delegate = self
		
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		
		resultSearchController = UISearchController(searchResultsController: autocompleteController)
		resultSearchController?.searchResultsUpdater = autocompleteController
		
        
		let searchBar = resultSearchController?.searchBar
		searchBar?.sizeToFit()
		searchBar?.placeholder = "Search for your destination"
        
        //FIXME: Search bar cancel button is not getting hidden
        searchBar?.showsCancelButton = false
        
		navigationItem.titleView = resultSearchController?.searchBar
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back ", style: .plain, target: self, action: #selector(back))
		
		resultSearchController?.hidesNavigationBarDuringPresentation = false
		resultSearchController?.dimsBackgroundDuringPresentation = true
		definesPresentationContext = true
		
		destinationLabel.text = destinationString
		addressLabel.text = addressString
		
    }
	
	func back() {
		self.dismiss(animated: true, completion: nil)
	}
	
	/*
	*****************************
	IBActions
	*****************************
	*/
	
	@IBAction func transportationTapped(recognizer: UITapGestureRecognizer) {
		let transportTypes = ["Car", "Walking", "Transit"]
        if let tappedTag = recognizer.view?.tag {
            for num in 0..<transportTypes.count {
                if tappedTag == num {
                    switch tappedTag {
                    case 0:
                        selectedTransportation = .Car
                    case 1:
                        selectedTransportation = .Walking
                    case 2:
                        selectedTransportation = .Transit
                    default:
                        selectedTransportation = .Car
                    }
                
                    transportImages[num].alpha = 1
                    transportTypeLabel.text = transportTypes[num]
                } else {
                    transportImages[num].alpha = 0.3
                }
            }
        }
	}
	
	@IBAction func confirmTapped(_ sender: Any) {
        if let destination = selectedDestination {
            self.delegate?.acceptDestinationData(destination: destination, transportation: selectedTransportation)
            self.dismiss(animated: true, completion: nil)
        } else {
            let alert: UIAlertController = UIAlertController(title: "No Destination Selected", message: "Select a destination to continue.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
	}
	
	/* 
	*****************************
	CLLocationManager Delegate functions
	*****************************
	*/
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.first {
			let span = MKCoordinateSpanMake(0.05, 0.05)
			let region = MKCoordinateRegion(center: location.coordinate, span: span)
			mapView.setRegion(region, animated: true)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("ERROR: \(error.localizedDescription)")
	}
	
	
	
	/*
	*****************************
	GMSAutocompleteViewControllerDelegate Functions
	*****************************
	*/
	
	func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
		resultsController.dismiss(animated: true, completion: nil)
		let span = MKCoordinateSpanMake(0.05, 0.05)
		let region = MKCoordinateRegion(center: place.coordinate, span: span)
		mapView.setRegion(region, animated: true)
		
		let annotation = MKPointAnnotation()
		annotation.coordinate = place.coordinate
		annotation.title = "Destination"
		
		if mapView.annotations.count > 0 {
			mapView.removeAnnotations(mapView.annotations)
		}

		destinationString = place.name
		addressString = place.formattedAddress!
		selectedDestination = place
        
		mapView.addAnnotation(annotation)
		
	}
	
	func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
		print("Autocomplete failed")
	}

}
