//
//  CustomPickerCellTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 31/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

enum CellType {
    case type
    case status
	case price
	case occurance
}

class CustomPickerCellTableViewCell: MainCreateScrimmageCellTableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    var pickerData: [String]!
    var isFilled = false
    var selectedInput: String!
	var selectedIntValue: Int?
	var selectedDoubleValue: Double!
    var picker: UIPickerView!
	var isDataValid = true
	var currentType: CellType!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func configureCell(with title: String, placeHolder: String, keyboardType: UIKeyboardType?, target: UIViewController?, action: Selector?, type: CellType?) {
		self.setupCellUI()
        self.inputTextField.delegate = self
        let attributedPlaceHolder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.inputTextField.attributedPlaceholder = attributedPlaceHolder        
        self.titleLabel.text = "   " + title
        pickerData = pickerData(for: type!)
        self.picker = UIPickerView()
        self.picker.backgroundColor = .black

        self.picker.showsSelectionIndicator = true
        self.picker.delegate = self
        self.picker.dataSource = self

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

        self.inputTextField.inputView = picker
        self.inputTextField.inputAccessoryView = toolBar
    }
	
	override func hasValidData() -> Bool {
		
		if inputTextField.text!.isEmpty {
			isDataValid = false
			return false
		} else {
			isDataValid = true
			return true
		}
	}
	
	func setupCellUI() {
		if !isDataValid {
			self.inputTextField.layer.borderColor = UIColor.red.cgColor
			self.inputTextField.layer.borderWidth = 1.5
		} else {
			self.inputTextField.layer.borderColor = UIColor.lightGray.cgColor
			self.inputTextField.layer.borderWidth = 1.5
		}
		
	}
    
    @objc func donePicker() {
        if selectedInput != nil {
            self.isFilled = true
        }
        self.inputTextField.text = selectedInput
        self.inputTextField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedInput = pickerData[row]
		self.selectedIntValue = row + 1
		self.selectedDoubleValue = Double(row)
        self.inputTextField.text = self.selectedInput
    }
    
    func pickerData(for type: CellType) -> [String] {
        
        var pickerData = [String]()
		
		switch type {
		case .status:
			pickerData = ["Confirmed", "Provisional"]
			self.currentType = .status
		case .type:
			pickerData = ["Public", "Private"]
			self.currentType = .type
		case .occurance:
			pickerData = ["one-time", "weekly"]
			self.currentType = .occurance
		case .price:
			pickerData = ["Free", "£1", "£2", "£3", "£4", "£5", "£6", "£7", "£8", "£10", "£11"]
			self.currentType = .price
		}
        return pickerData
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        let string = pickerData[row]
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return pickerData.count
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputTextField {
            self.picker.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(picker, attributedTitleForRow: 0, forComponent: 0)
            self.selectedInput = pickerData.first
			self.selectedIntValue = 1
			self.selectedDoubleValue = 1.0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		if currentType == .price {
			returnValue?(selectedDoubleValue ?? 0.0) // Use callback to return data
		} else {
			returnValue?(selectedIntValue ?? 0) // Use callback to return data
		}
        
    }
	
}
