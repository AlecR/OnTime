//
//  HomeVC.swift
//  Commute Clock
//
//  Created by Alec Rodgers on 1/16/17.
//  Copyright © 2017 Alec Rodgers. All rights reserved.
//

import UIKit
import MapKit

class HomeVC: UIViewController {

	@IBOutlet weak var mapView: MKMapView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	/*
	*****************************
	MapView functions
	*****************************
	*/
	
	func createRoute(coordsOne: CLLocationCoordinate2D, coordsTwo: CLLocationCoordinate2D) {
		let request = MKDirectionsRequest()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordsOne))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: coordsTwo))
		request.requestsAlternateRoutes = false
		request.transportType = .automobile
		
		let directions = MKDirections(request: request)
		
		directions.calculate { (response, error) in
			if error != nil {
				print("ALEC: Error getting directions")
			} else {
				if let response = response {
					let routes = response.routes
					
					let fastest = routes.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime })[0]
					//let fastestTime = fastest.expectedTravelTime
					
					self.mapView.add(fastest.polyline)
					self.mapView.setVisibleMapRect(fastest.polyline.boundingMapRect, animated: true)
					
				}
			}
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		let polylineRenderer = MKPolylineRenderer(overlay: overlay)
		polylineRenderer.strokeColor = UIColor.blue
		polylineRenderer.lineWidth = 5
		return polylineRenderer
		
	}

}
