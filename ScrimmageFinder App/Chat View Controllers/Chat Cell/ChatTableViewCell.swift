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
		
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
