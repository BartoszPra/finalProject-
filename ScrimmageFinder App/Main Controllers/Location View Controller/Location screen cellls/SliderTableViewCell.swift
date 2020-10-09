//
//  sliderTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 16/07/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

protocol LocationCellDelegate: class {
	
	func sliderValueSelected(value: Double)
}

class SliderTableViewCell: UITableViewCell {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var slider: UISlider!
	@IBOutlet weak var suggestedLabel: UILabel!
	@IBOutlet weak var selectionIndicator: UIImageView!
	@IBOutlet weak var sliderStack: UIStackView!
	weak var delegate: LocationCellDelegate?
	private let sugestedRadius =  80.0
	let step: Float = 5
	
	func configureCell(isCellSelected: Bool, radius: Double, indexPath: IndexPath) {
				
		switch indexPath.row {
		case 0:
			self.selectionIndicator.backgroundColor = isCellSelected ? .systemBlue : .white
			slider.isHidden = true
			suggestedLabel.isHidden = true
			sliderStack.isHidden = true
			titleLabel.text = "Suggested Radius"
			if isCellSelected {
				delegate?.sliderValueSelected(value: sugestedRadius)
			}
		case 1:
			slider.isHidden = false
			suggestedLabel.isHidden = false
			sliderStack.isHidden = false
			titleLabel.text = "Custom Radius"
			let newRadius = isCellSelected ? radius : sugestedRadius
			self.selectionIndicator.backgroundColor = isCellSelected ? .systemBlue : .white
			self.suggestedLabel.text = isCellSelected ? "\(newRadius) km" : "Suggested"
			self.slider.isEnabled = isCellSelected //? true : false
			self.slider.minimumValue = 0
			self.slider.maximumValue = 100
			self.slider.setValue(Float(newRadius), animated: true)
			slider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
		default:
			slider.isHidden = false
			suggestedLabel.isHidden = false
			sliderStack.isHidden = false
			titleLabel.text = "Custom Radius"
		}
    }

	@objc func sliderValueDidChange(sender: UISlider!) {
		let roundedValue = round(sender.value / step) * step
		sender.value = roundedValue
		suggestedLabel.text = "\(Int(roundedValue)) km"
		delegate?.sliderValueSelected(value: Double(roundedValue))
	}
		
	override func prepareForReuse() {
		super.prepareForReuse()
		self.selectionIndicator.backgroundColor = .white
	}
}
