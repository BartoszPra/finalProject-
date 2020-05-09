//
//  DetailTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 11/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import MapKit

class CustomPin: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	
	init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D) {
		self.title = pinTitle
		self.subtitle = pinSubtitle
		self.coordinate = location
	}
}

class AddressTableViewCell: MainDetailTableViewCell {

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	
	var targett: UIViewController!
	
	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, viewModel: ScrimmageViewModel) {
		
		self.titleLabel.text = title
		self.contentLabel.text = viewModel.address
		self.iconImageView.image = icon
		if title == "Name" {
			self.iconImageView.layer.cornerRadius = iconImageView.bounds.width/2
			self.iconImageView.layer.masksToBounds = true
		}
		targett = target
		
		let location = CLLocationCoordinate2D(latitude: viewModel.geopoint.latitude, longitude: viewModel.geopoint.longitude)
		let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
		self.mapView.setRegion(region, animated: true)
		
		let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(mapTapped(_:)))
		gestureRecognizer.delegate = self
				
		let pin = CustomPin(pinTitle: viewModel.name, pinSubtitle: viewModel.timeString, location: location)
		self.mapView.addAnnotation(pin)
		mapView.addGestureRecognizer(gestureRecognizer)
	}
	
	@objc func mapTapped(_ gestureRecognizer: UILongPressGestureRecognizer) {
		let vc = targett as? SFDetailsViewController
		vc!.mapTapped()
	}
}
