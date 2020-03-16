//
//  UIImageView+Extensions.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 29/02/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

let imageCashe = NSCache<NSString, UIImage>()

extension UIImageView {
	
	func loadImageUsingCashe(scrimmageId: String) {
		
		if let caschedImage = imageCashe.object(forKey: scrimmageId as NSString) {
			self.image = caschedImage
			return
		}
		
		FIRFirestoreService.shared.getScrimmageImage(for: scrimmageId) { (image) in
			imageCashe.setObject(image, forKey: scrimmageId as NSString)
			self.image = image
		}
	}
}
