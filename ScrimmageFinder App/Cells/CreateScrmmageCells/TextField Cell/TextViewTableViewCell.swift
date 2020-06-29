//
//  TextViewTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 24/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class TextViewTableViewCell: MainCreateScrimmageCellTableViewCell, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
	var isDataValid = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	override func configureCell(with title: String, editableData: Any?, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?, isEdit: Bool) {
		self.setupCellUI()
		self.inputTextField.delegate = self
        let attributedPlaceHolder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        titleLabel.text = "    " + title
        inputTextField.attributedPlaceholder = attributedPlaceHolder
        inputTextField.keyboardType = keyboardType!
		if isEdit, let data = editableData {
			self.inputTextField.text = editableData as? String
		}
    }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
        returnValue?(inputTextField.text ?? "")
    }
	
	override func hasValidData() -> Bool {
		
		if inputTextField.text == nil || inputTextField.text!.isEmpty {
			isDataValid = false
			return false
		} else {
			isDataValid = true
			return true
		}
	}
	
	override func clearCell() {
		self.inputTextField.text = ""
	}
	
	func setupCellUI() {
		
		if !isDataValid {
			inputTextField.layer.borderColor = UIColor.red.cgColor
			inputTextField.layer.borderWidth = 1.0
		} else {
			inputTextField.layer.borderColor = UIColor.lightGray.cgColor
			inputTextField.layer.borderWidth = 1.0
		}
	}
}
