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
    }
	
	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, viewModel: ScrimmageViewModel) {
		if title == "Participate" {
			if viewModel.isParticipating && viewModel.participantStatus == .confirmed {
				self.button.setTitle("Cancel going", for: .normal)
				self.button.alpha = 1
				self.button.backgroundColor = .systemRed
				self.button.isEnabled = true
			} else if viewModel.isParticipating && viewModel.participantStatus == .unconfirmed {
				self.button.setTitle("Go", for: .normal)
				self.button.alpha = 1
				self.button.backgroundColor = .systemBlue
				self.button.isEnabled = true
			} else if viewModel.isParticipating && viewModel.participantStatus == .invited {
				self.button.setTitle("Respond", for: .normal)
				self.button.alpha = 1
				self.button.backgroundColor = .systemGreen
				self.button.isEnabled = true
			} else if !viewModel.isParticipating {
				self.button.setTitle("Join group", for: .normal)
				self.button.alpha = 1
				self.button.backgroundColor = .systemBlue
				self.button.isEnabled = true
			}
		} else if title == "Save" {
			if viewModel.isAlreadySaved {
				self.button.isEnabled = false
				self.button.alpha = 0.8
				self.button.setTitle("Saved", for: .normal)
				self.button.backgroundColor = .systemGreen
			} else {
				self.button.isEnabled = true
				self.button.alpha = 1
				self.button.setTitle(title, for: .normal)
				self.button.backgroundColor = .systemBlue
			}
		}
		// not sure why this needs to be there but needs investigation.
		button.removeTarget(target, action: action, for: .touchUpInside)
		button.addTarget(target, action: action!, for: .touchUpInside)
		button.layer.cornerRadius = 5
		button.clipsToBounds = true
	}    
}
