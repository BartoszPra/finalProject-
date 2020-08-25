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

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
		
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var mapView: MKMapView!
	
	private var selectedIndexPath: IndexPath?
	private var sugestedRadius = 80
	private var customRadius =  80
	private var city = ""
			
	override func viewDidLoad() {
        super.viewDidLoad()
		self.registerNib()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
		let buttonItem = MKUserTrackingButton(mapView: mapView)
		buttonItem.tintColor = .white
		buttonItem.backgroundColor = .lightGray
		self.mapView.addSubview(buttonItem)
		buttonItem.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			NSLayoutConstraint(item: buttonItem, attribute: .right, relatedBy: .equal, toItem: mapView, attribute: .right, multiplier: 1.0, constant: -5),
			NSLayoutConstraint(item: buttonItem, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .top, multiplier: 1.0, constant: 5)
		])
		buttonItem.layer.cornerRadius = 10
		buttonItem.clipsToBounds = true
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
	
	@IBAction func cancelPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func applypressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
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
