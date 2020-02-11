//
//  CellDefinitionHelper.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 26/01/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

struct CellDefinitionHelper {
	
	var cellTitle: String
	var object: UITableViewCell
	var identifier: String
	var keboardType: UIKeyboardType?
	var target: UIViewController?
	var action: Selector?
	var placeHolder: String
	var color: UIColor?
	var type: CellType?
	var height: CGFloat
	
}
