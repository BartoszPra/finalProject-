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

protocol SFLocationDelegate {
	func locationUpdated(city: String)
}


class SFLocationManager: NSObject, CLLocationManagerDelegate {
	
	let locationManager = CLLocationManager()
	weak var delegate: CLLocationManagerDelegate!
	var currentLocation: CLLocationCoordinate2D?
	var place: CLPlacemark?
	var locDelegate: SFLocationDelegate!
	
	override init() {
		super.init()		
		// For use in foreground
		locationManager.delegate = self
		self.locationManager.requestAlwaysAuthorization()
		self.locationManager.requestWhenInUseAuthorization()
		if CLLocationManager.locationServicesEnabled() {
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
		}
	}
		
	func getCurrentLocation() {
		if CLLocationManager.locationServicesEnabled() {
			locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
			locationManager.startUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
		print("locations = \(locValue.latitude) \(locValue.longitude)")
		self.currentLocation = locValue
		
		self.geocode(latitude: self.currentLocation!.latitude, longitude: self.currentLocation!.longitude) { (place) in
			print(place.locality)
			self.locDelegate.locationUpdated(city: place.locality!)
		}
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