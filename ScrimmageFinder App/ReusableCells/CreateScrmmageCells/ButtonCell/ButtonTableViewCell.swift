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
    
    override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
		var buttonColor: UIColor
		if title == "Add Scrimmage" {
			buttonColor = UIColor.orange
		} else {
			buttonColor = UIColor.black
		}
        self.actionButton.setTitle(title, for: .normal)
        self.actionButton.backgroundColor = buttonColor
		self.actionButton.addTarget(target, action: action!, for: .touchUpInside)
    }
    
}
