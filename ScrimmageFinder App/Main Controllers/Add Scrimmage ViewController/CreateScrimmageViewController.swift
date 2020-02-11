//
//  CreateScrimmageViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 24/12/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

struct CellDefinition {
    
    var title: String
    var type: UITableViewCell
}

class CreateScrimmageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    @IBOutlet weak var tableView: UITableView!
    var imagePicker = UIImagePickerController()
	var cellArray: [CellDefinitionHelper]!
    
	//scrimmage variables
	var name: String!
	var contactName: String!
	var contactNumber: String!
	var address: String!
	var geolocation: CLLocationCoordinate2D!
	var currentStatus: Int!
	var currentType: Int!
	var image: UIImage!
	var price: Double!
	var time: String!
	var date: String!
	var notes: String!
		
    override func viewDidLoad() {
        super.viewDidLoad()
		createCells()
        imagePicker.delegate = self
        self.title = "New Scrimmage"
        self.setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupTableView() {
  
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.setupCells()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismisssKeyboard))
        self.tableView.addGestureRecognizer(tap)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
		return cellArray[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        			
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellArray[indexPath.row].identifier,
													   for: indexPath) as? MainCreateScrimmageCellTableViewCell else {return MainCreateScrimmageCellTableViewCell()}
		
		cell.configureCell(with: cellArray[indexPath.row].cellTitle,
						   placeHolder: cellArray[indexPath.row].placeHolder,
						   keyboardType: cellArray[indexPath.row].keboardType,
						   target: self,
						   action: cellArray[indexPath.row].action, type: cellArray[indexPath.row].type)
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
        let addressPickerNib = UINib(nibName: "AddressCellTableViewCell", bundle: nil)
        tableView.register(addressPickerNib, forCellReuseIdentifier: "addressCell")
		let textViewNib = UINib(nibName: "TextViewCellTableViewCell", bundle: nil)
        tableView.register(textViewNib, forCellReuseIdentifier: "textViewCell")
    }
    
    @objc func invitePlayers() {
        print("Players Invited")
    }
    
    @objc func submitStringmmage() {
        print("Scrimmage Added")
		
		// swiftlint:disable:next line_length
		print("Name: " + name +  "\n" + "contactName: " + contactName + "\n" + "contactNumber" + contactNumber + "\n" + "address: " + address + "\n")
		print("currentStatus: \(self.currentStatus!)" + "\n" + "currentType: " + "\(self.currentType!)" + "\n" + "date: " + "\(self.date!)" + "\n")
		print("lat: " + "\(self.geolocation.latitude)\n" + "lon: " + "\(self.geolocation.longitude)")
		// swiftlint:enable:next line_length
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
    
    @objc private func keyboardWillShow(notification: NSNotification) {
       if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           if self.view.frame.origin.y == 0 {
               self.view.frame.origin.y -= 60  //keyboardSize.height
           }
       }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
	func createNewScrimmage() {
		
	}
	
	func createCells() {
		
		let pictureCell = CellDefinitionHelper(cellTitle: "Picture", object: LogoTableViewCell(), identifier: "logoCell", keboardType: nil, target: self, action: #selector(imageTapped(tapGestureRecognizer:)), placeHolder: "selectPicture", color: nil, type: nil, height: 58)
		let nameCell = CellDefinitionHelper(cellTitle: "Name", object: TextViewTableViewCell(), identifier: "textFieldCell", keboardType: .default, target: nil, action: nil, placeHolder: "Name", color: nil, type: nil, height: 58)
		let timeCell = CellDefinitionHelper(cellTitle: "Time", object: PickerTableViewCell(), identifier: "pickerCell", keboardType: nil, target: nil, action: nil, placeHolder: "Time", color: nil, type: nil, height: 58)
		let priceCell = CellDefinitionHelper(cellTitle: "Price", object: CustomPickerCellTableViewCell(), identifier: "customPickerCell", keboardType: nil, target: self, action: #selector(imageTapped(tapGestureRecognizer:)), placeHolder: "select Price", color: nil, type: .price, height: 58)
		let organizerName = CellDefinitionHelper(cellTitle: "Organizer Name", object: TextViewTableViewCell(), identifier: "textFieldCell", keboardType: .default, target: nil, action: nil, placeHolder: "Specify organizers name", color: nil, type: nil, height: 58)
		let dateCell = CellDefinitionHelper(cellTitle: "Date", object: PickerTableViewCell(), identifier: "pickerCell", keboardType: nil, target: nil, action: nil, placeHolder: "Date", color: nil, type: nil, height: 58)
		let contactNumberCell = CellDefinitionHelper(cellTitle: "Contact Number", object: TextViewTableViewCell(), identifier: "textFieldCell", keboardType: .phonePad, target: nil, action: nil, placeHolder: "Specify contact number", color: nil, type: nil, height: 58)
		let addressCell = CellDefinitionHelper(cellTitle: "Address", object: AddressCellTableViewCell(), identifier: "addressCell", keboardType: nil, target: self, action: #selector(autocompleteClicked), placeHolder: "select address", color: nil, type: nil, height: 58)
		let typeCell = CellDefinitionHelper(cellTitle: "Type", object: CustomPickerCellTableViewCell(), identifier: "customPickerCell", keboardType: nil, target: self, action: nil, placeHolder: "select type", color: nil, type: .type, height: 58)
		let statusCell = CellDefinitionHelper(cellTitle: "Status", object: CustomPickerCellTableViewCell(), identifier: "customPickerCell", keboardType: nil, target: self, action: nil, placeHolder: "select status", color: nil, type: .status, height: 58)
		let occuranceCell = CellDefinitionHelper(cellTitle: "Occurance", object: CustomPickerCellTableViewCell(), identifier: "customPickerCell", keboardType: nil, target: self, action: nil, placeHolder: "select status", color: nil, type: .occurance, height: 58)
		let inviteButtonCell = CellDefinitionHelper(cellTitle: "Invite Players", object: ButtonTableViewCell(), identifier: "buttonCell", keboardType: nil, target: self, action: #selector(invitePlayers), placeHolder: "", color: nil, type: nil, height: 58)
		let submitButtonCell = CellDefinitionHelper(cellTitle: "Add Scrimmage", object: ButtonTableViewCell(), identifier: "buttonCell", keboardType: nil, target: self, action: #selector(submitStringmmage), placeHolder: "", color: nil, type: nil, height: 58)
		let notesCell = CellDefinitionHelper(cellTitle: "Notes", object: TextViewTableViewCell(), identifier: "textViewCell", keboardType: nil, target: self, action: #selector(submitStringmmage), placeHolder: "Please issert mesage to players", color: nil, type: nil, height: 75)
		
		cellArray = [pictureCell, nameCell, organizerName, contactNumberCell, timeCell, dateCell, addressCell, priceCell, typeCell, statusCell, occuranceCell, notesCell, inviteButtonCell, submitButtonCell]
				
	}
        
}

extension CreateScrimmageViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        let index = IndexPath(row: 6, section: 0)
        guard let cell = tableView.cellForRow(at: index) as? AddressCellTableViewCell else { return }
        
        cell.addressTextField.text = (place.name ?? "") + ",\n " + (place.formattedAddress ?? "")
		self.address = place.formattedAddress
		self.geolocation = place.coordinate
        cell.addressTextField.textColor = .white
        tableView.reloadData()
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Canceled")
        viewController.dismiss(animated: true, completion: nil)
    }
	
	@objc func autocompleteClicked(_ sender: UIButton) {
      let autocompleteController = GMSAutocompleteViewController()
      autocompleteController.delegate = self

      // Specify the place data types to return.
      let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
        UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
      autocompleteController.placeFields = fields

      // Specify a filter.
      let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
      autocompleteController.autocompleteFilter = filter

      // Display the autocomplete view controller.
      present(autocompleteController, animated: true, completion: nil)
    }
}
