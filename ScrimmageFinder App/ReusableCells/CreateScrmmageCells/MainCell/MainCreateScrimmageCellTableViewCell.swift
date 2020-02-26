//
//  MainCreateScrimmageCellTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 28/01/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class MainCreateScrimmageCellTableViewCell: UITableViewCell {

	var returnValue: ((_ value: Any) -> Void)?
	
	func hasValidData() -> Bool {return false}
	
	func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {}
}
