//
//  SavedScrimmagesCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 05/08/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class ScrimmagesCell: BaseCell<ScrimmageViewModel> {

    @IBOutlet weak var cellLBL: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!
    
	override var item: ScrimmageViewModel! {
		didSet {
			cellLBL.text = item.name
			addressLbl.text = item.venueName
			timeLbl.text = "Price: £\(String(format: "%.2f", item.price)), Time: " + item.timeString
			statusImage.image = ScrimmageStatus(rawValue: item.currentStatus)?.statusImage
			item.getImage { [weak self] (image) in
				self?.cellImage.image = image
			}
		}
	}
}
