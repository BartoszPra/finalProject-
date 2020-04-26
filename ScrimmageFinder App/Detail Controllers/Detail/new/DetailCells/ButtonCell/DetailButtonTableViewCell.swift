//
//  DetailButtonTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 15/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class DetailButtonTableViewCell: MainDetailTableViewCell {

	@IBOutlet weak var button: UIButton!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, isCurrentUserParticipating: Bool, participantsStatus: ParticipantsStatus?) {
		if title == "Participate" {
			if isCurrentUserParticipating {
				self.button.setTitle("Not going", for: .normal)
			} else {
				self.button.setTitle("Going", for: .normal)
			}
		} else {
			self.button.setTitle(title, for: .normal)
		}
		self.button.addTarget(target, action: action!, for: .touchUpInside)
		self.button.layer.cornerRadius = 5
		self.button.clipsToBounds = true
	}
    
}
