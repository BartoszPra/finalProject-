//
//  AddressCellTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 02/01/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class AddressCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressTextField: UITextView!
    
    func configureCell(with placeHolder: String, target: UIViewController, action: Selector) {
        self.addressTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.addressTextField.layer.borderWidth = 1
        //let attributedPlaceHolder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        //self.addressTextField.text = placeHolder
        
        let gesture = UITapGestureRecognizer(target: target, action: action)
        self.addressTextField.addGestureRecognizer(gesture)
        
    }
}
