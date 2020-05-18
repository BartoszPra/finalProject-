//
//  LogoTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 30/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class LogoTableViewCell: MainCreateScrimmageCellTableViewCell, UIImagePickerControllerDelegate {

    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var addLogoImage: UIImageView!
    var imagePicker = UIImagePickerController()
    var scrimmageLogo: UIImage!
	var isDataValid = true
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
	override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
        scrimmageLogo = logoImage.image
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        photoView.addGestureRecognizer(gestureRecognizer)
        
    }
	
	override func clearCell() {
		self.logoImage.image =  UIImage(named: "grayBballLogo")
	}
	
	override func hasValidData() -> Bool {
		
		if logoImage.image != nil {
			isDataValid = true
			return true
		} else {
			isDataValid = false
			return false
		}
	}
}
