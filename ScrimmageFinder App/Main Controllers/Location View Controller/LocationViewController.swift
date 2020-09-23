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

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
		
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var mapView: MKMapView!
	var locationManager = CLLocationManager()
	@IBOutlet weak var regionView: UIView!
	
	private var selectedIndexPath: IndexPath?
	private var sugestedRadius = 80
	private var customRadius =  80
	private var city = ""
	
	var currLocation: CLLocation!
			
	override func viewDidLoad() {
        super.viewDidLoad()
		self.registerNib()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.currLocation = locationManager.location
		self.mapView.delegate = self
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
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
		
		cell.configureCell(isCellSelected: isSelectedCell, radius: sugestedRadius, indexPath: indexPath)
		return cell
		
	}
	
	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
		let flowHeightConstraint = self.regionView.heightAnchor.constraint(equalToConstant: self.regionView.frame.height - 20)
		let flowwidthConstraint = self.regionView.widthAnchor.constraint(equalToConstant: self.regionView.frame.width - 20)
		flowHeightConstraint.isActive = true
		flowwidthConstraint.isActive = true
		self.view.layoutIfNeeded()

	}
	
	@IBAction func cancelPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func applypressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func moveToCurrentLoc(_ sender: Any) {
		mapView.setCenter(currLocation.coordinate, animated: true)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedIndexPath = indexPath
		self.tableView.reloadData()
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
}
