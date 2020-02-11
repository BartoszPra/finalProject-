//
//  AddressCellTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 02/01/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class AddressCellTableViewCell: MainCreateScrimmageCellTableViewCell {
    
    @IBOutlet weak var addressTextField: UILabel!
    
    override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
        self.addressTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.addressTextField.layer.borderWidth = 1.5
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.addressTextField.addGestureRecognizer(gesture)        
    }
}
