//
//  DetailTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 11/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

enum DetailCellType {
    case text
    case textAndButton
}

class DetailTableViewCell: MainDetailTableViewCell {

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
	
	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, viewModel: ScrimmageViewModel) {
	
		self.titleLabel.text = title
		self.contentLabel.text = contentText
		if title == "Name" {
			viewModel.getImage { (image) in
				self.iconImageView.image = image
			}
			self.iconImageView.layer.cornerRadius = iconImageView.bounds.width/2
			self.iconImageView.layer.masksToBounds = true
		} else {
			self.iconImageView.image = icon
		}
	}    
}
