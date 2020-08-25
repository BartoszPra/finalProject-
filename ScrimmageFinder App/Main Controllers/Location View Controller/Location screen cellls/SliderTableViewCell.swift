//
//  sliderTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 16/07/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var suggestedLabel: UILabel!
	@IBOutlet weak var selectionIndicator: UIImageView!
	@IBOutlet weak var sliderStack: UIStackView!
	
	let step: Float = 10
	
	func configureCell(isCellSelected: Bool, radius: Int, indexPath: IndexPath) {
		self.selectionIndicator.backgroundColor = isCellSelected ? .systemBlue : .white
		self.suggestedLabel.text = isCellSelected ? "\(radius) km" : "Suggested"
		self.slider.isEnabled = isCellSelected ? true : false
		self.slider.minimumValue = 0
		self.slider.maximumValue = 100
		
		self.slider.setValue(Float(radius), animated: true)
				
		slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
				
		switch indexPath.row {
		case 0:
			slider.isHidden = true
			suggestedLabel.isHidden = true
			titleLabel.text = "Suggested Radius"
		case 1:
			slider.isHidden = false
			suggestedLabel.isHidden = false
			titleLabel.text = "Custom Radius"
		default:
			slider.isHidden = false
			suggestedLabel.isHidden = false
			titleLabel.text = "Custom Radius"
		}
    }

	@objc func sliderValueDidChange(sender: UISlider!) {
		let roundedValue = round(sender.value / step) * step
		sender.value = roundedValue
		suggestedLabel.text = "\(Int(roundedValue)) km"
	}
		
	override func prepareForReuse() {
		super.prepareForReuse()
		self.selectionIndicator.backgroundColor = .white
	}
}
