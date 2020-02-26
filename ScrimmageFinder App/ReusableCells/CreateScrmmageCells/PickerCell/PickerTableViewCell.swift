//
//  PickerTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 26/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class PickerTableViewCell: MainCreateScrimmageCellTableViewCell, UITextFieldDelegate {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var inputField: UITextField!
    var picker: UIDatePicker!
    var selectedDate: Date!
    var isFilled = false
    var selectedDateString: String!
	var isDataValid = true
        
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
	
	override func hasValidData() -> Bool {
		if inputField.text!.isEmpty {
			isDataValid = false
			return false
		} else {
			isDataValid = true
			return true
		}
	}
        
	override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
		self.setupCellUI()
		self.inputField.delegate = self
        let attributedPlaceHolder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.inputField.attributedPlaceholder = attributedPlaceHolder
        self.title.text = "    " + title        
        self.picker = UIDatePicker()
		self.picker.datePickerMode = self.decidePickerType(for: title)
        self.picker.minimumDate = Date()
        self.picker.backgroundColor = .black
        self.picker.tintColor = .white
        self.picker.setValue(UIColor.white, forKeyPath: "textColor")
        self.picker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.black
        toolBar.isTranslucent = true
        toolBar.tintColor = .white
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        inputField.inputView = picker
        inputField.inputAccessoryView = toolBar
    }
	
	func setupCellUI() {
		if !isDataValid {
			self.inputField.layer.borderColor = UIColor.red.cgColor
			self.inputField.layer.borderWidth = 1.5
		} else {
			self.inputField.layer.borderColor = UIColor.lightGray.cgColor
			self.inputField.layer.borderWidth = 1.5
		}
		
	}
	
	func decidePickerType(for title: String) -> UIDatePicker.Mode {
		
		if title == "Date" {
			return UIDatePicker.Mode.date
			
		} else if title == "Time" {
			return UIDatePicker.Mode.time
		}
		return UIDatePicker.Mode.date
	}
    
    @objc func donePicker() {
        inputField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ picker: UIDatePicker) {
        
        if picker.datePickerMode == .date {
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            selectedDate = picker.date
            selectedDateString = dateFormatter.string(from: picker.date)
			inputField.text = dateFormatter.string(from: picker.date)
            print("Selected value" + selectedDateString)
        
        } else if picker.datePickerMode == .time {
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            selectedDate = picker.date
            selectedDateString = dateFormatter.string(from: picker.date)
			inputField.text = dateFormatter.string(from: picker.date)
            print("Selected value" + selectedDateString)
        }
    }
	
	func textFieldDidBeginEditing(_ textField: UITextField) {
       
		if textField == inputField {
			let dateFormatter: DateFormatter = DateFormatter()
			if picker.datePickerMode == .date {
				dateFormatter.dateFormat = "dd/MM/yyyy"
				picker.date = Date()
				selectedDate = Date()
				inputField.text = dateFormatter.string(from: picker.date)
			} else if picker.datePickerMode == .time {
				let theDateAnHourFromNow = NSDate().addingTimeInterval(3600)
				dateFormatter.dateFormat = "HH:mm"
				picker.date = theDateAnHourFromNow as Date
				selectedDate = theDateAnHourFromNow as Date
				inputField.text = dateFormatter.string(from: picker.date)

			}
		}
    }
		
	func textFieldDidEndEditing(_ textField: UITextField) {
        returnValue?(inputField.text ?? "") // Use callback to return data
    }
}
