//
//  ScrimmagesViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 28/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import CoreLocation
import MapKit
import FirebaseFirestore

class ScrimmagesListViewController: MasterViewController<ScrimmagesCell, ScrimmageViewModel>, SFLocationDelegate, LocationViewDelegate {
	
	@IBOutlet weak var newTable: UITableView!
	
	var locationButton: UIBarButtonItem!
	var coordinator: ScrimmagesCoordinator?
	var locationManager: SFLocationManager!
	var service = FIRFirestoreService.shared
	var isCurrentLocationUseOn = false
		
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView = newTable
		createBarButtons()
		locationManager = SFLocationManager(delegate: self)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.getScrimages()
	}
	
	func getScrimages() {		
		if let check = checkForSelectedLocationAndRegion() {
			getScrimmagesForLoc(location: check)
		} else {
			AlertController.showOkAllertWothChandler(self, title: "No Location", message: "We could not get your location. Please choose location where you want to see scrimmages.") { (_) in
				self.coordinator?.goToLocationChange(delegate: self)
			}
		}
	}
	
	deinit {
		service.removeListener()
		print("MainVC was deinit")
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let scrimmage = items[indexPath.row]
		let cell = newTable.cellForRow(at: indexPath) as? ScrimmagesCell
		coordinator?.goToNewDetail(with: scrimmage, from: self, image: cell?.cellImage.image ?? UIImage())
	}

	func getScrimmagesForLoc(location: CLLocation) {
		self.items.removeAll()
		service.getScrimmagesFromRegion(center: location, radius: checkForRegion()) {[weak self] (scrimage, changeType) in
			if changeType == .added {
				let model = ScrimmageViewModel(scrimmage: scrimage)
				self?.items.append(model)
			} else {
				let model = ScrimmageViewModel(scrimmage: scrimage)
				if let index = self?.items.index(of: model) {
					self?.items.remove(at: index)
				}
			}
			self?.tableView.reloadData()
		}
	}
	
	func checkForSelectedLocationAndRegion() -> CLLocation? {
		
		var returnedLocation: CLLocation
		let defaults = UserDefaults.standard
		if let savedLat = defaults.object(forKey: "latitude") as? CLLocationDegrees,
			let savedLon = defaults.object(forKey: "longitude") as? CLLocationDegrees {
			let location = CLLocationCoordinate2D(latitude: savedLat, longitude: savedLon)
			self.locationManager.geocodeLocation(location: location)
			returnedLocation = CLLocation(latitude: savedLat, longitude: savedLon)
			return returnedLocation
		} else {
			isCurrentLocationUseOn = true
			if let lat = locationManager.currentLocation?.latitude, let lon = locationManager.currentLocation?.longitude {
				returnedLocation = CLLocation(latitude: lat, longitude: lon)
			} else {
				return nil
			}
		}
		return nil
	}
	
	func checkForRegion() -> Double {
		
		let sugestedRadius = 80.0
		var returnedRegion: Double
		let defaults = UserDefaults.standard
		if let savedRegion = defaults.object(forKey: "region") as? Double {
			returnedRegion = savedRegion
		} else {
			returnedRegion = sugestedRadius
		}
		return returnedRegion
	}
		
	@objc func goToLocationChange() {
        self.coordinator?.goToLocationChange(delegate: self)
    }
	
	func createBarButtons() {
		
		locationButton = UIBarButtonItem(image: UIImage(named: "location"), style: .plain, target: self, action: #selector(goToLocationChange))
		navigationItem.rightBarButtonItem = locationButton
		
		let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(self.logOutClicked))
		navigationItem.leftBarButtonItem = logoutButton
		
		self.view.backgroundColor = .black
		let image = UIImage(named: "black")!.alpha(0.7)
		navigationController?.navigationBar.setBackgroundImage(image, for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		ViewHelpers.setLogoAsNavigationTitle(imageName: "logoNoBackgroundBrighter", on: self)
		
	}
	
	func updateLocationButton(city: String) {
		self.locationButton = UIBarButtonItem(image: UIImage(named: "location")!, title: city, target: self, action: #selector(goToLocationChange))
		navigationItem.rightBarButtonItem = locationButton
	}
	
	func locationUpdated(city: String) {
		self.updateLocationButton(city: city)
	}
	
	func locationHasChanged(location: CLLocationCoordinate2D) {
			self.locationManager.geocodeLocation(location: location)
			self.getScrimages()
	}	
}
