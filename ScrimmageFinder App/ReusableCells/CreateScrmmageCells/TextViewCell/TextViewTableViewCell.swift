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
	
	var returnValue: ((_ value: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
	override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
		self.inputTextField.delegate = self
        let attributedPlaceHolder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        titleLabel.text = "    " + title
        inputTextField.attributedPlaceholder = attributedPlaceHolder
        inputTextField.keyboardType = keyboardType!
    }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
        returnValue?(inputTextField.text ?? "")
    }
}
