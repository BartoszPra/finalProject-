//
//  ChatTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
	
	@IBOutlet weak var chatImage: UIImageView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var subName: UILabel!
	@IBOutlet weak var checkImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func configureWithCheckBox(isEnabled: Bool) {
		if isEnabled {
			checkImage.layer.masksToBounds = true
			checkImage.layer.borderWidth = 1.0
			checkImage.layer.borderColor = UIColor.white.cgColor
			checkImage.layer.cornerRadius = checkImage.bounds.width / 2
		}
	}
}
