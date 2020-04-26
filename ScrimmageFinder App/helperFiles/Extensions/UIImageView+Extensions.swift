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
		
		self.image = nil
		
		if let caschedImage = imageCashe.object(forKey: scrimmageId as NSString) {
			self.image = caschedImage
			return
		}
		
		FIRFirestoreService.shared.getScrimmageImage(for: scrimmageId) { (image) in
			imageCashe.setObject(image, forKey: scrimmageId as NSString)
			self.image = image
		}
	}
	
	func loadImageUsingCashe(urlString: String, completion: @escaping (UIImage) -> Void) {
		
		self.image = nil
		
		if let caschedImage = imageCashe.object(forKey: urlString as NSString) {
			completion(caschedImage)
		}
		
		guard let url = URL(string: urlString) else {return}
		DispatchQueue.global().async {
			if let data = try? Data(contentsOf: url) {
				if let image = UIImage(data: data) {
					DispatchQueue.main.async {
						imageCashe.setObject(image, forKey: urlString as NSString)
						completion(image)
					}
				}
			}
		}
	}
	
	func returnImageUsingCashe(userId: String, completion: @escaping (UIImage) -> Void) {
		
		self.image = nil
		
		if let caschedImage = imageCashe.object(forKey: userId as NSString) {
			completion(caschedImage)
		}
		
		FIRFirestoreService.shared.getProfileImage(for: userId) { (image) in
			imageCashe.setObject(image, forKey: userId as NSString)
			completion(image)
		}
	}
	
	func loadUserImageUsingCashe(userId: String) {
		
		self.image = nil
		
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
