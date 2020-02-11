//
//  LogoTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 30/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class LogoTableViewCell: MainCreateScrimmageCellTableViewCell, UIImagePickerControllerDelegate {

    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var addLogoImage: UIImageView!
    var imagePicker = UIImagePickerController()
    var scrimmageLogo: UIImage!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
	override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
        scrimmageLogo = logoImage.image
        let gestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        photoView.addGestureRecognizer(gestureRecognizer)
        
    }
}
