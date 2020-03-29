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
	
	func returnImageUsingCashe(userId: String, completion: @escaping (UIImage) -> Void) {
		
		if let caschedImage = imageCashe.object(forKey: userId as NSString) {
			completion(caschedImage)
		}
		
		FIRFirestoreService.shared.getProfileImage(for: userId) { (image) in
			imageCashe.setObject(image, forKey: userId as NSString)
			completion(image)
		}
	}
	
	func loadUserImageUsingCashe(userId: String) {
		
		if let caschedImage = imageCashe.object(forKey: userId as NSString) {
			self.image = caschedImage
			return
		}
		
		FIRFirestoreService.shared.getProfileImage(for: userId) { (image) in
			imageCashe.setObject(image, forKey: userId as NSString)
			self.image = image
		}
	}
}
