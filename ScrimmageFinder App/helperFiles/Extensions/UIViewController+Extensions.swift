//
//  UIViewController+Extensions.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 15/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

var vSpinner: UIView?

extension UIViewController {
	
	open override func awakeFromNib() {
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
    
    func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicator)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
	
	func setImageAndTextTitle(_ title: String, andImage image: UIImage) {
		let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
		titleLbl.text = title
		titleLbl.textColor = UIColor.white
		titleLbl.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
		let imageView = UIImageView(image: image)
		imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
		let titleView = UIStackView(arrangedSubviews: [imageView, titleLbl])
		///titleView.frame  = CGRect(x: 50, y: 50, width: 200, height: 50)
		
		titleView.axis = .horizontal
		titleView.spacing = 5.0
		navigationItem.titleView = titleView
	}
}
