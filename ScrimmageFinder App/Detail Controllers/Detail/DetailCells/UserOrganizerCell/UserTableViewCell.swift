//
//  TableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 04/02/2021.
//  Copyright © 2021 The App Experts. All rights reserved.
//

import UIKit

class UserTableViewCell: MainDetailTableViewCell {

	@IBOutlet weak var nameButton: UIButton!
	@IBOutlet weak var messageButton: UIButton!
	@IBOutlet weak var infoButton: UIButton!
	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var phoneButton: UIButton!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func configureCell(title: String, contentText: String, icon: UIImage, target: UIViewController?, action: Selector?, viewModel: ScrimmageViewModel, user: User?) {
		
		nameButton.titleLabel?.text = title
		if let user = user {
			phoneButton.isHidden = user.phoneNumber == nil
			if let url = user.imageUrl {
				iconView.smoothRoundCorners(to: 10)
				UIImageView().loadImageUsingCashe(urlString: url) { (img) in
					self.iconView.image = img
				}
			} else {
				self.iconView.image = icon
			}
		}
	}
}
