//
//  LocationViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 02/07/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol LocationViewDelegate: class {
	func locationHasChanged(location: CLLocationCoordinate2D)
}

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, LocationCellDelegate {
		
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var mapView: MKMapView!
	@IBOutlet weak var regionView: UIView!
	
	//circleViewConstraint
	@IBOutlet weak var width: NSLayoutConstraint!
	@IBOutlet weak var height: NSLayoutConstraint!
	
	private let sugestedRadius =  80.0
	var locationManager = CLLocationManager()
	private var selectedIndexPath: IndexPath?
	private var selectedRadius = 80.0
	weak var delegate: LocationViewDelegate?
	private var city = ""
	var currLocation: CLLocationCoordinate2D!
	var selectedLocation: CLLocationCoordinate2D!
		
	override func viewDidLoad() {
        
		super.viewDidLoad()
		self.registerNib()
		
		locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		self.currLocation = locationManager.location?.coordinate
				
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.mapView.delegate = self
		locationManager.delegate = self
		
    }
	
	override func viewDidAppear(_ animated: Bool) {
		checkForSelectedLocationAndRegion()
	}
	
	deinit {
		print("location controller has been removed")
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell",
		for: indexPath) as? SliderTableViewCell else { return SliderTableViewCell() }
		let isSelectedCell = indexPath == self.selectedIndexPath
		cell.configureCell(isCellSelected: isSelectedCell, radius: selectedRadius, indexPath: indexPath)
		cell.delegate = self
		return cell
		
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		resizeRegionView(kilometers: selectedRadius)
		self.selectedLocation = mapView.centerCoordinate
	}
	
	@IBAction func cancelPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func applypressed(_ sender: Any) {
		saveLocationAndRegionToDefaults(location: selectedLocation, region: selectedRadius)
		delegate?.locationHasChanged(location: selectedLocation)
		self.dismiss(animated: true, completion: nil)
		
	}
	
	func saveLocationAndRegionToDefaults(location: CLLocationCoordinate2D, region: Double?) {
		let defaults = UserDefaults.standard
		defaults.set(selectedLocation.latitude, forKey: "latitude")
		defaults.set(selectedLocation.longitude, forKey: "longitude")
		defaults.set(region, forKey: "region")
	}
	
	@IBAction func moveToCurrentLoc(_ sender: Any) {
		if currLocation != nil {
			mapView.setCenter(currLocation, animated: true)
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath != self.selectedIndexPath {
			self.selectedIndexPath = indexPath
			self.tableView.reloadData()
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		switch indexPath.row {
		case 0:
			return 80
		case 1:
			return 110
		default:
			return 110
		}
	}
	
	func registerNib() {
		let nib = UINib(nibName: "SliderTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "sliderCell")
	}
	
	func KMToMeters(km: Int) -> Int {
		let meetersToMiles = 1000 * km
		return meetersToMiles
	}
	
	func setRegion(KMs: Int) {
		mapView.region = MKCoordinateRegion(
			center: self.mapView.centerCoordinate,
			latitudinalMeters: CLLocationDistance(KMToMeters(km: KMs)),
			longitudinalMeters: CLLocationDistance(KMToMeters(km: KMs))
		)
	}
	
	func checkForSelectedLocationAndRegion() {
		
		let defaults = UserDefaults.standard
		if let savedLat = defaults.object(forKey: "latitude") as? CLLocationDegrees,
		   let savedLon = defaults.object(forKey: "longitude") as? CLLocationDegrees {
			let savedLocation = CLLocationCoordinate2D(latitude: savedLat, longitude: savedLon)
			selectedLocation = savedLocation
		} else {
			selectedLocation = currLocation
		}
		if let savedRegion = defaults.object(forKey: "region") as? Double {
			selectedRadius = savedRegion
			selectedIndexPath = IndexPath(item: 1, section: 0)
		} else {
			selectedRadius = sugestedRadius
			selectedIndexPath = IndexPath(item: 0, section: 0)
		}
		
		if let loc = self.selectedLocation {
			self.mapView.setCenter(loc, animated: false)
		}
		self.resizeRegion(kilometers: selectedRadius)
		self.tableView.reloadData()
	}
	
	func resizeRegion(kilometers: Double) {
		self.resizeRegionView(kilometers: kilometers)
		let region = MKCoordinateRegion( center: self.mapView.centerCoordinate, latitudinalMeters: CLLocationDistance(exactly: kilometers * 2500)!, longitudinalMeters: CLLocationDistance(exactly: kilometers * 2500)!)
		mapView.setRegion(mapView.regionThatFits(region), animated: true)
	}
	
	func sliderValueSelected(value: Double) {
		self.selectedRadius = value
		self.resizeRegion(kilometers: selectedRadius)
	}
}

extension LocationViewController: MKMapViewDelegate {
	
	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		
		var circleRenderer = MKCircleRenderer()
		if let overlay = overlay as? MKCircle {
			circleRenderer = MKCircleRenderer(circle: overlay)
			circleRenderer.fillColor = UIColor.blue
			circleRenderer.strokeColor = .white
			circleRenderer.alpha = 0.5
			
		}
		return circleRenderer
	}
	
	func resizeRegionView(kilometers: Double) {
		
		let pixelMaKM =  mapView.region.span.latitudeDelta * 111 / Double(mapView.frame.height)
		let wielkoscKolka = (2 * kilometers) / pixelMaKM
		let wielkoscKolkaRounded = (wielkoscKolka*10).rounded()/10
		let cgKolko = CGFloat(wielkoscKolkaRounded)
		
		width.constant = cgKolko
		height.constant = cgKolko
		
		self.regionView.layer.cornerRadius = cgKolko / 2
		
		self.view.updateConstraints()
		self.view.layoutIfNeeded()
	}
}
