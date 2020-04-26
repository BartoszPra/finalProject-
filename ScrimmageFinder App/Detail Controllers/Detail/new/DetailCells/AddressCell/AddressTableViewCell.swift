//
//  DetailTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 11/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class AddressTableViewCell: MainDetailTableViewCell {

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var contentLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, isCurrentUserParticipating: Bool, participantsStatus: ParticipantsStatus?) {
		
		self.titleLabel.text = title
		self.contentLabel.text = contentText
		self.iconImageView.image = icon
		if title == "Name" {
			self.iconImageView.layer.cornerRadius = iconImageView.bounds.width/2
			self.iconImageView.layer.masksToBounds = true
		}
	}    
}
