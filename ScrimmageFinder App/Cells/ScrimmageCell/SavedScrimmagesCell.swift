//
//  SavedScrimmagesCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 05/08/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class SavedScrimmagesCell: UITableViewCell {

    @IBOutlet weak var cellLBL: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var statusImage: UIImageView!    
	
	func configureCell(scrimmage: ScrimmageViewModel) {
		
		cellLBL.text = scrimmage.name
		addressLbl.text = scrimmage.venueName
		timeLbl.text = "Price: £\(String(format: "%.2f", scrimmage.price)), Time: " + scrimmage.timeString
		statusImage.image = ScrimmageStatus(rawValue: scrimmage.currentStatus)?.statusImage
		scrimmage.getImage { (image) in
			self.cellImage.image = image
		}
	}
}
