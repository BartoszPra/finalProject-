//
//  ButtonTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 30/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class ButtonTableViewCell: MainCreateScrimmageCellTableViewCell {
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
	override func configureCell(with title: String, editableData: Any?, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?, isEdit: Bool) {
		var buttonColor: UIColor
		if title == "Add Scrimmage" {
			buttonColor = UIColor.orange
			if isEdit {
				self.actionButton.setTitle("Update", for: .normal)
			} else {
				self.actionButton.setTitle(title, for: .normal)
			}
		} else {
			buttonColor = UIColor.black
			self.actionButton.setTitle(title, for: .normal)
		}
        		
        self.actionButton.backgroundColor = buttonColor
		self.actionButton.addTarget(target, action: action!, for: .touchUpInside)
    }
	
	override func hasValidData() -> Bool {
		return true
	}
    
}
