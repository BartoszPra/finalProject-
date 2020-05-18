//
//  AddressCellTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 02/01/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class AddressCellTableViewCell: MainCreateScrimmageCellTableViewCell {
    
    @IBOutlet weak var addressTextField: UILabel!
	var isDataValid = true
	let addressPlaceHolder = "Please add address"
    
    override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
		self.setupCellUI()
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.addressTextField.addGestureRecognizer(gesture)        
    }
	
	override func hasValidData() -> Bool {
		
		if addressTextField.text != addressPlaceHolder {
			isDataValid = true
			return true
		} else {
			isDataValid = false
			return false
		}
	}
	
	override func clearCell() {
		self.addressTextField.text = addressPlaceHolder
	}
	
	func setupCellUI() {
		if !isDataValid {
			self.addressTextField.layer.borderColor = UIColor.red.cgColor
			self.addressTextField.layer.borderWidth = 1.5
		} else {
			self.addressTextField.layer.borderColor = UIColor.lightGray.cgColor
			self.addressTextField.layer.borderWidth = 1.5
		}
		
	}
}
