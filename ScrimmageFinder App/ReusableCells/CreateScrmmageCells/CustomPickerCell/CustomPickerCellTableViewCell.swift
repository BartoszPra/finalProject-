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
}

class CustomPickerCellTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    var pickerData: [String]!
    var isFilled = false
    var selectedInput: String!
    var picker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    func setupCell(with title: String, placeHolder: String, type: CellType) {
        self.inputTextField.delegate = self
        let attributedPlaceHolder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        self.inputTextField.attributedPlaceholder = attributedPlaceHolder        
        self.titleLabel.text = "   " + title
        pickerData = pickerData(for: type)
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
    
    @objc func donePicker() {
        if selectedInput != nil {
            self.isFilled = true
        }
        self.inputTextField.text = selectedInput
        self.inputTextField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedInput = pickerData[row]
        self.inputTextField.text = self.selectedInput
    }
    
    @objc func pickerValueChanged(_ picker: UIPickerView) {
        
    }
    
    func pickerData(for type: CellType) -> [String] {
        
        var pickerData = [String]()
        
        if type == .status {
            pickerData = ["Confirmed", "Not confirmed"]
        } else if  type == .type {
            pickerData = ["Private", "Public"]
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
        return 2
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputTextField {
            self.picker.selectRow(0, inComponent: 0, animated: true)
            self.pickerView(picker, attributedTitleForRow: 0, forComponent: 0)
            self.selectedInput = pickerData.first
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
