//
//  ButtonTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 30/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with buttonTitle: String, buttonColor: UIColor, action: Selector, target: UIViewController) {
        self.actionButton.setTitle(buttonTitle, for: .normal)
        self.actionButton.backgroundColor = buttonColor
        self.actionButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
}
