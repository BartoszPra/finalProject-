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
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, isCurrentUserParticipating: Bool, participantsStatus: ParticipantsStatus?) {
		self.seeeParticipantsButton.tag = 1
		self.titleLabel.text = title
		self.contentLabel.text = contentText
		self.iconImageView.image = icon
		self.seeeParticipantsButton.addTarget(target, action: action!, for: .touchUpInside)
		if participantsStatus != nil {
			self.statusLabel.isHidden = false
			self.statusLabel.textColor = participantsStatus?.color
			self.statusLabel.text = participantsStatus?.description			
		} else {
			self.statusLabel.isHidden = true
		}
		
	}
}
