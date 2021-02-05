//
//  MapKitExtension.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 04/02/2021.
//  Copyright © 2021 The App Experts. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension MKMapItem {
  convenience init(coordinate: CLLocationCoordinate2D, name: String) {
	self.init(placemark: .init(coordinate: coordinate))
	self.name = name
  }
}
