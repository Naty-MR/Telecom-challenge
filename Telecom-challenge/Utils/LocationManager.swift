//
//  LocationManager.swift
//  Telecom-challenge
//
//  Created by Natalia MR on 2/10/23.
//

import Foundation
import MapKit

protocol LocationDelegate {
	func didGetLocation(lat: Double, lon: Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
	let delegate: LocationDelegate
	var locationManager = CLLocationManager()
	
	init(_ delegate: LocationDelegate) {
		self.delegate = delegate
		super.init()
		self.locationManager.requestAlwaysAuthorization()
		self.locationManager.requestWhenInUseAuthorization()
		DispatchQueue.global().async {
			if CLLocationManager.locationServicesEnabled() {
				self.locationManager.delegate = self
				self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
				self.locationManager.startUpdatingLocation()
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let loc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
		delegate.didGetLocation(lat: loc.latitude, lon: loc.longitude)
	}
}
