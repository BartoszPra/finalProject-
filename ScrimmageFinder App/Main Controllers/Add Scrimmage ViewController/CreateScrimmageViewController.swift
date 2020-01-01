//
//  CreateScrimmageViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 24/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

struct CellDefinition {
    
    var title: String
    var type: UITableViewCell
}

class CreateScrimmageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var addScrimmageArray: [CellDefinition]!
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.title = "New Scrimmage"
        self.setupTableView()
    }
    
    func setupTableView() {
  
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupCells()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismisssKeyboard))
        self.tableView.addGestureRecognizer(tap)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        } else {
            return 54
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell        
        switch indexPath.row {
            
        case 0:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "logoCell",
                                                              for: indexPath) as? LogoTableViewCell else { return LogoTableViewCell()}
            celldef.configureCell(with: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            cell = celldef
        case 1:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "textFieldCell",
                                                              for: indexPath) as? TextViewTableViewCell else { return TextViewTableViewCell()}
            celldef.cofnfigureCell(with: "Name", placeHolder: "Please insert name", keyboardType: UIKeyboardType.default)
            cell = celldef
        case 2:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "pickerCell",
                                                              for: indexPath) as? PickerTableViewCell else { return PickerTableViewCell()}
            celldef.setupCell(with: UIDatePicker.Mode.date, title: "Date", placeHolder: "Please insert date")
            cell = celldef
            
        case 3:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "pickerCell",
                                                              for: indexPath) as? PickerTableViewCell else { return PickerTableViewCell()}
            celldef.setupCell(with: UIDatePicker.Mode.time, title: "Time", placeHolder: "Please insert time")
            cell = celldef
            
        case 4:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "textFieldCell",
                                                              for: indexPath) as? TextViewTableViewCell else { return TextViewTableViewCell()}
            celldef.cofnfigureCell(with: "Contact Number", placeHolder: "Please insert contact number", keyboardType: UIKeyboardType.phonePad)
            cell = celldef
            
        case 5:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "textFieldCell",
                                                              for: indexPath) as? TextViewTableViewCell else { return TextViewTableViewCell()}
            celldef.cofnfigureCell(with: "Contact Name", placeHolder: "Please insert contact name", keyboardType: UIKeyboardType.default)
            cell = celldef
            
        case 6:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "textFieldCell",
                                                              for: indexPath) as? TextViewTableViewCell else { return TextViewTableViewCell()}
            celldef.cofnfigureCell(with: "Address", placeHolder: "Please add the venue Address", keyboardType: UIKeyboardType.default)
            cell = celldef
            
        case 7:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "customPickerCell",
                                                              for: indexPath) as? CustomPickerCellTableViewCell else { return CustomPickerCellTableViewCell()}
            celldef.setupCell(with: "Status", placeHolder: "Please insert scrimmage status", type: .status)
            cell = celldef
        
        case 8:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "customPickerCell",
                                                              for: indexPath) as? CustomPickerCellTableViewCell else { return CustomPickerCellTableViewCell()}
            celldef.setupCell(with: "Type", placeHolder: "Please insert scrimmage type", type: .type)
            cell = celldef
        
        case 9:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "buttonCell",
                                                              for: indexPath) as? ButtonTableViewCell else { return ButtonTableViewCell()}
            celldef.configureCell(with: "Invite Players", buttonColor: UIColor.clear, action: #selector(self.invitePlayers), target: self)
            cell = celldef
            
        case 10:
            guard let celldef = tableView.dequeueReusableCell(withIdentifier: "buttonCell",
                                                              for: indexPath) as? ButtonTableViewCell else { return ButtonTableViewCell()}
            celldef.configureCell(with: "Submit Scrimmage", buttonColor: UIColor.orange, action: #selector(self.submitStringmmage), target: self)
            cell = celldef
            
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    func setupCells() {
        let nib = UINib(nibName: "TextViewTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "textFieldCell")
        let pickerNib = UINib(nibName: "PickerTableViewCell", bundle: nil)
        tableView.register(pickerNib, forCellReuseIdentifier: "pickerCell")
        let logoNib = UINib(nibName: "LogoTableViewCell", bundle: nil)
        tableView.register(logoNib, forCellReuseIdentifier: "logoCell")
        let buttonNib = UINib(nibName: "ButtonTableViewCell", bundle: nil)
        tableView.register(buttonNib, forCellReuseIdentifier: "buttonCell")
        let customPickerNib = UINib(nibName: "CustomPickerCellTableViewCell", bundle: nil)
        tableView.register(customPickerNib, forCellReuseIdentifier: "customPickerCell")
    }
    
    @objc func invitePlayers() {
        print("Players Invited")
    }
    
    @objc func submitStringmmage() {
        print("Scrimmage Added")
    }
    
    func createCellDictionaryArray() {
        let scrimmageName = CellDefinition(title: "Name:", type: TextViewTableViewCell())
        let scrimmageDate = CellDefinition(title: "Date", type: PickerTableViewCell())
        
        self.addScrimmageArray = [scrimmageName, scrimmageDate]
                
    }
    
    @objc func dismisssKeyboard() {
        self.tableView.endEditing(true)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let index = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: index) as? LogoTableViewCell
            cell!.logoImage.image = pickedImage
            tableView.reloadData()
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let index = IndexPath(row: 0, section: 0)
            let cell = tableView.cellForRow(at: index) as? LogoTableViewCell
            cell!.logoImage.image = pickedImage
            tableView.reloadData()
        }
        dismiss(animated: true, completion: nil)
    }
}
