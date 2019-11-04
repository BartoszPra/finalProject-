//
//  SavedScrimmagesCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 05/08/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class MyScrimmagesCell: UITableViewCell {
    
    @IBOutlet weak var cellLBL: UILabel!
    @IBOutlet weak var addressLBL: UILabel!
    @IBOutlet weak var timeLBL: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
