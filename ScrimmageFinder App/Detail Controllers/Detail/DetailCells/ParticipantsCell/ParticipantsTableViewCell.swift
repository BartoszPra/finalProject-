//
//  ParticipantsTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 16/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class ParticipantsTableViewCell: MainDetailTableViewCell {

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var seeeParticipantsButton: UIButton!
	@IBOutlet weak var statusLabel: UILabel!
	
	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, viewModel: ScrimmageViewModel, user: User?) {
		self.seeeParticipantsButton.tag = 1
		self.titleLabel.text = title
		self.contentLabel.text = contentText
		self.iconImageView.image = icon
		self.seeeParticipantsButton.addTarget(target, action: action!, for: .touchUpInside)
		if viewModel.participantStatus != nil {
			self.statusLabel.isHidden = false
			self.statusLabel.textColor = viewModel.participantStatus?.color
			self.statusLabel.text = viewModel.participantStatus?.description
		} else {
			self.statusLabel.isHidden = true
		}
	}
}
