//
//  NewScrimmageTableViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 10/05/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class NewScrimmageTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddUsersDelegate {
	
	private var imagePicker = UIImagePickerController()
	private var cellArray: [CellDefinitionHelper]!
	private var isEdit: Bool!
	private let db = Firestore.firestore()
	private var channelReference: CollectionReference {
		return db.collection("chats")
	}
	//scrimmage variables
	var name: String!
	var contactName: String!
	var venueName: String!
	var contactNumber: String!
	var address: String!
	var geolocation: GeoPoint!
	var currentStatus: Int!
	var currentType: Int!
	var image: UIImage = UIImage.init(named: "bballLogo")!
	var price: Double!
	var time: String!
	var date: String!
	var notes: String!
	var newSid: String!
	var invitedUsers = [String: ParticipantsStatus]()
	var scrimmageValues = [String: Any]()
	
	init(isEdit: Bool) {
		super.init(style: .plain)
		self.isEdit = isEdit
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("Detail is deinint !!! The detail!!!!!!!!")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		createCells()
		imagePicker.delegate = self
		self.title = "New Scrimmage"
		self.setupTableView()
	}
	
	func setupTableView() {
		self.setupCells()
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismisssKeyboard))
		tableView.addGestureRecognizer(tap)
		self.tableView.backgroundColor = .black
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellArray.count
	}
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return cellArray[indexPath.row].height
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellArray[indexPath.row].identifier,
													   for: indexPath) as? MainCreateScrimmageCellTableViewCell else {return MainCreateScrimmageCellTableViewCell()}
		
		cell.configureCell(with: cellArray[indexPath.row].cellTitle,
						   placeHolder: cellArray[indexPath.row].placeHolder,
						   keyboardType: cellArray[indexPath.row].keboardType,
						   target: self,
						   action: cellArray[indexPath.row].action,
						   type: cellArray[indexPath.row].type)
		
		cell.returnValue = { value in
			self.scrimmageValues.updateValue(value, forKey: self.cellArray[indexPath.row].cellTitle)
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
		let addressPickerNib = UINib(nibName: "AddressCellTableViewCell", bundle: nil)
		tableView.register(addressPickerNib, forCellReuseIdentifier: "addressCell")
		let textViewNib = UINib(nibName: "TextViewCellTableViewCell", bundle: nil)
		tableView.register(textViewNib, forCellReuseIdentifier: "textViewCell")
	}
	
	@objc func invitePlayers() {
		let vc = ChooseUsersViewController(nibName: "ChooseUsersViewController", bundle: nil, usage: .scrimmageInvite)
		vc.delegate = self
		navigationController?.pushViewController(vc, animated: true)
	}
	
	@objc func submitStringmmage() {
		
		if self.checkIfAllDatailsFilled() {
			//fix so its on succe
			addScrimmage { (succ) in
				if succ {
					self.clearCells()
					AlertController.showAllert(self, title: "Congratulations", message: "Your Scrimmage has been added")					
				} else {
					AlertController.showAllert(self, title: "Problem", message: "There was a problem adding Scrimmage")
				}
			}
		} else {
			AlertController.showAllert(self, title: "Missing Information", message: "Please fill the marked fields")
		}
	}
	
	@objc func dismisssKeyboard() {
		self.tableView.endEditing(true)
	}
	
	func clearCells() {
		self.scrimmageValues = [String: Any]()
		for cell in cellArray.indices {
			let index2 = IndexPath(row: cell, section: 0)
			let cell2 = tableView.cellForRow(at: index2) as? MainCreateScrimmageCellTableViewCell
			cell2?.clearCell()
		}
		tableView.reloadData()
	}
	
	@objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
		imagePicker.allowsEditing = true
		imagePicker.sourceType = .photoLibrary
		self.navigationController?.present(imagePicker, animated: true, completion: nil)
		
	}
	
	func checkIfAllDatailsFilled() -> Bool {
		
		var boolToReturn = true
		
		for cell in cellArray.dropFirst().indices {
			let index2 = IndexPath(row: cell, section: 0)
			let cell2 = tableView.cellForRow(at: index2) as? MainCreateScrimmageCellTableViewCell
			if !cell2!.hasValidData() {
				boolToReturn = false
			}
		}
		tableView.reloadData()
		return boolToReturn
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		
		if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
			
			let index = IndexPath(row: 0, section: 0)
			let cell = tableView.cellForRow(at: index) as? LogoTableViewCell
			cell!.logoImage.image = pickedImage
			self.image = pickedImage
			tableView.reloadData()
		} else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			let index = IndexPath(row: 0, section: 0)
			let cell = tableView.cellForRow(at: index) as? LogoTableViewCell
			cell!.logoImage.image = pickedImage
			self.image = pickedImage
			tableView.reloadData()
		}
		dismiss(animated: true, completion: nil)
	}
	
	func uploadScrimmagePhoto() {
		FIRFirestoreService.shared.uploadImage(image: self.image, uploadType: .scrimmageImage, for: newSid, for: "123") { (success) in
			if success {
				print("Scrimmage photo updated")
			} else {
				print("There was error uploading photos")
			}
		}
	}
	
	func addScrimmage(completion: @escaping (Bool) -> Void) {
		FIRFirestoreService.shared.uploadImage(self.image, folderName: "ScrimmageAndChat") { (url) in
			self.createChannel(chatName: (self.scrimmageValues["Name"] as? String)!, users: [""], chatImageUrl: url!.absoluteString) { (chatId) in
				self.createNewScrimmage(chatId: chatId!, imageUrl: url!.absoluteString) { (succ) in
					if succ {
						completion(true)
					} else {
						completion(false)
					}
				}
			}
		}
	}
	
	func createChannel(chatName: String, users: [String], chatImageUrl: String, completion: @escaping (String?) -> Void) {
		let channel = Chat(name: chatName, users: users, isGroup: true, url: chatImageUrl)
		var ref: DocumentReference? = nil
		ref = channelReference.addDocument(data: channel.representation) { (error) in
			if let e = error {
				print("Error saving channel: \(e.localizedDescription)")
			} else {
				completion(ref?.documentID)
			}
		}
	}
	
	func createNewScrimmage(chatId: String, imageUrl: String, completion: @escaping (Bool) -> Void) {
		// composing a scrimmage
		let dateformat = DateFormatter()
		dateformat.dateFormat =  "E, dd/MM/yyyy HH:mm"
		let date: String = (scrimmageValues["Date"] as? String)!
		//let time: String = (scrimmageValues["Time"] as? String)!
		guard let dateObj = dateformat.date(from: date) else {return}
		
		let scrimmage = Scrimmage(name: (scrimmageValues["Name"] as? String)!,
								  venueName: venueName,
								  address: address,
								  dateTime: dateObj,
								  managerName: (scrimmageValues["Organizer Name"] as? String)!,
								  managerNumber: (scrimmageValues["Contact Number"] as? String)!,
								  price: (scrimmageValues["Price"] as? Double)!,
								  createdById: Auth.auth().currentUser!.uid,
								  currentStatus: (scrimmageValues["Status"] as? Int)!,
								  currentType: (scrimmageValues["Type"] as? Int)!,
								  participants: invitedUsers,
								  geopoint: geolocation,
								  notes: (scrimmageValues["Notes"] as? String)!,
								  chatId: chatId,
								  imageUrl: imageUrl)
		// creating a scrimmage
		newSid = FIRFirestoreService.shared.create(for: scrimmage, in: .scrimmages, completion: { (success) in
			if success {
				completion(true)
			} else {
				completion(false)
			}
		})
		print(newSid + "Im here with id")
	}
	
	func createCells() {
		
		let pictureCell = CellDefinitionHelper(cellTitle: "Picture",
											   identifier: "logoCell",
											   keboardType: nil, target: self, action: #selector(imageTapped(tapGestureRecognizer:)),
											   placeHolder: "selectPicture", color: nil, type: nil, height: 58)
		let nameCell = CellDefinitionHelper(cellTitle: "Name",
											identifier: "textFieldCell",
											keboardType: .default, target: nil, action: nil,
											placeHolder: "Name", color: nil, type: nil, height: 58)
		let priceCell = CellDefinitionHelper(cellTitle: "Price",
											 identifier: "customPickerCell", keboardType: nil, target: self,
											 action: #selector(imageTapped(tapGestureRecognizer:)),
											 placeHolder: "select Price", color: nil, type: .price, height: 58)
		let organizerName = CellDefinitionHelper(cellTitle: "Organizer Name",
												 identifier: "textFieldCell",
												 keboardType: .default, target: nil, action: nil,
												 placeHolder: "Specify organizers name", color: nil, type: nil, height: 58)
		let dateCell = CellDefinitionHelper(cellTitle: "Date",
											identifier: "pickerCell", keboardType: nil, target: nil, action: nil,
											placeHolder: "Date", color: nil, type: nil, height: 58)
		let contactNumberCell = CellDefinitionHelper(cellTitle: "Contact Number",
													 identifier: "textFieldCell", keboardType: .phonePad, target: nil,
													 action: nil, placeHolder: "Specify contact number", color: nil, type: nil, height: 58)
		let addressCell = CellDefinitionHelper(cellTitle: "Address",
											   identifier: "addressCell", keboardType: nil, target: self,
											   action: #selector(autocompleteClicked), placeHolder: "select address", color: nil, type: nil, height: 58)
		let typeCell = CellDefinitionHelper(cellTitle: "Type",
											identifier: "customPickerCell", keboardType: nil,
											target: self, action: nil,
											placeHolder: "select type", color: nil,
											type: .type, height: 58)
		let statusCell = CellDefinitionHelper(cellTitle: "Status",
											  identifier: "customPickerCell", keboardType: nil,
											  target: self, action: nil,
											  placeHolder: "select status", color: nil,
											  type: .status, height: 58)
		let occuranceCell = CellDefinitionHelper(cellTitle: "Occurance",
												 identifier: "customPickerCell", keboardType: nil,
												 target: self, action: nil,
												 placeHolder: "select status", color: nil, type: .occurance, height: 58)
		let inviteButtonCell = CellDefinitionHelper(cellTitle: "Invite Players",
													identifier: "buttonCell",
													keboardType: nil, target: self, action: #selector(invitePlayers), placeHolder: "",
													color: nil, type: nil, height: 58)
		let submitButtonCell = CellDefinitionHelper(cellTitle: "Add Scrimmage",
													identifier: "buttonCell",
													keboardType: nil, target: self, action: #selector(submitStringmmage), placeHolder: "", color: nil, type: nil, height: 58)
		let notesCell = CellDefinitionHelper(cellTitle: "Notes",
											 identifier: "textViewCell",
											 keboardType: nil,
											 target: self,
											 action: nil, placeHolder: "Please issert mesage to players", color: nil, type: nil, height: 75)
		
		cellArray = [pictureCell, nameCell, organizerName,
					 contactNumberCell, dateCell,
					 addressCell, priceCell, typeCell,
					 statusCell, occuranceCell, notesCell,
					 inviteButtonCell, submitButtonCell]
		
	}
	
	func passUsers(users: [User], title: String, image: UIImage, isGrouped: Bool) {
		for user in users {
			invitedUsers.updateValue(ParticipantsStatus(rawValue: 3)!, forKey: user.id!)
		}
	}
}

extension NewScrimmageTableViewController: GMSAutocompleteViewControllerDelegate {
	
	func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
		dismiss(animated: true, completion: nil)
		let index = IndexPath(row: 5, section: 0)
		guard let cell = tableView.cellForRow(at: index) as? AddressCellTableViewCell else { return }
		
		cell.addressTextField.text = (place.name ?? "") + ",\n " + (place.formattedAddress ?? "")
		self.address = place.formattedAddress
		self.venueName = place.name
		_ = place.addressComponents //for future if needed all the components of the address
		self.geolocation = GeoPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
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
		let fields: GMSPlaceField = GMSPlaceField(rawValue:
			UInt(GMSPlaceField.name.rawValue) |
				UInt(GMSPlaceField.formattedAddress.rawValue) |
				UInt(GMSPlaceField.coordinate.rawValue) |
				UInt(GMSPlaceField.placeID.rawValue) |
				UInt(GMSPlaceField.addressComponents.rawValue))!
		autocompleteController.placeFields = fields
		// Specify a filter.
		let filter = GMSAutocompleteFilter()
		filter.type = .noFilter
		autocompleteController.autocompleteFilter = filter
		// Display the autocomplete view controller.
		present(autocompleteController, animated: true, completion: nil)
	}
}
