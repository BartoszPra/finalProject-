//
//  PickerTableViewCell.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 26/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class PickerTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var inputField: UITextField!
    var picker: UIDatePicker!
    var selectedDate: Date!
    var isFilled = false
    var selectedDateString: String!
        
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
        
    func setupCell(with pickerType: UIDatePicker.Mode, title: String, placeHolder: String) {
        
        let attributedPlaceHolder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.inputField.attributedPlaceholder = attributedPlaceHolder
        self.title.text = title        
        self.picker = UIDatePicker()
        self.picker.datePickerMode = pickerType
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
    
    @objc func donePicker() {
        if selectedDate != nil {
            self.isFilled = true
        }
        inputField.text = selectedDateString
        inputField.resignFirstResponder()
    }
    
    @objc func datePickerValueChanged(_ picker: UIDatePicker) {
        
        if picker.datePickerMode == .date {
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            selectedDate = picker.date
            selectedDateString = dateFormatter.string(from: picker.date)
            print("Selected value" + selectedDateString)
        
        } else if picker.datePickerMode == .time {
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            selectedDate = picker.date
            selectedDateString = dateFormatter.string(from: picker.date)
            print("Selected value" + selectedDateString)
        }
    }
}
