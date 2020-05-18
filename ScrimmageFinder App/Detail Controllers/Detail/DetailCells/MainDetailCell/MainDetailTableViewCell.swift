//
//  MainDetailTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 15/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class MainDetailTableViewCell: UITableViewCell {
	
	var returnValue: ((_ value: Any) -> Void)?
	weak var mapDelegate: MapCellDelegate?
	var viewm: ScrimmageViewModel?
	
	func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, viewModel: ScrimmageViewModel) {
		self.viewm = viewModel
	}
	
	deinit {
		viewm = nil
	}
}
