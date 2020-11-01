//
//  SFLocationManager.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 07/08/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

protocol SFLocationDelegate: class {
	func locationUpdated(city: String)
}

class SFLocationManager: NSObject, CLLocationManagerDelegate {
	
	let locationManager = CLLocationManager()
	weak var delegate: CLLocationManagerDelegate!
	var currentLocation: CLLocationCoordinate2D?
	var place: CLPlacemark?
	weak var locDelegate: SFLocationDelegate!
	
	init(delegate: SFLocationDelegate) {
		super.init()
		self.locDelegate = delegate
		locationManager.delegate = self
		self.locationManager.requestWhenInUseAuthorization()
		if CLLocationManager.locationServicesEnabled() {
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.requestLocation()
		}
	}
	
	func getCurrentLocation() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		let locValue = locations[0].coordinate
		self.currentLocation = locValue
		self.geocodeLocation(location: currentLocation!)
	}
	
	func geocodeLocation(location: CLLocationCoordinate2D) {
		self.geocode(latitude: location.latitude, longitude: location.longitude) { (place) in
			if let city = place.locality {
				print(city)
				self.locDelegate.locationUpdated(city: city)
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
		
	func geocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CLPlacemark) -> Void) {
	  let location = CLLocation(latitude: latitude, longitude: longitude)
	  let geocoder = CLGeocoder()

	  var placemark: CLPlacemark?

	  geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
		if error != nil {
		  print("something went horribly wrong")
		}

		if let placemarks = placemarks {
			placemark = placemarks.first
			completion(placemark!)
		}
	  }
	}
}
