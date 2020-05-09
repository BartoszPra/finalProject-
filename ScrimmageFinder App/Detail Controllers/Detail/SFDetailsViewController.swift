//
//  SFDetailsViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 11/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class SFDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	
	var cellsArray = [DetailCellDefinition]()
	var isSavedUsed: Bool!
	var coordinator: ScrimmagesDetailCoordinator?
	var viewModel: ScrimmageViewModel!
    private let coreDataController = CoreDataController.shared // not used access to code data
    private var userID: String!
	var scrimmageImage = UIImage()
	private let db = Firestore.firestore()
	private var channelReference: CollectionReference {
		return db.collection("chats")
	}
	
	init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle?, scrimmage: ScrimmageViewModel, isSavedUsed: Bool) {
        super.init(nibName: nibNameOrNil as String, bundle: nibBundleOrNil)
        self.isSavedUsed = isSavedUsed
		self.viewModel = scrimmage
    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		observeScrimmage()
		self.userID = Auth.auth().currentUser?.uid
		self.tableView.delegate = self
        self.tableView.dataSource = self
		createCells()
		setupNavigationController()
		setupCells()		
        UserDefaults.standard.register(defaults: [String: Any]())
    }
		
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellsArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellsArray[indexPath.row].identifier,
													   for: indexPath) as? MainDetailTableViewCell else {return MainDetailTableViewCell()}
		
		cell.configureCell(title: cellsArray[indexPath.row].title,
						   contentText: cellsArray[indexPath.row].content,
						   icon: cellsArray[indexPath.row].awatar,
						   target: self,
						   action: cellsArray[indexPath.row].action,
						   viewModel: viewModel)
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if indexPath.row == 10 {
			return 200
		} else if indexPath.row == 11 {
			tableView.estimatedRowHeight = 60
			return UITableView.automaticDimension
		} else {
			return 60
		}
	}
	
	func setupCells() {
		let nib = UINib(nibName: "DetailTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "DetailCell")
		
		let buttonCellnib = UINib(nibName: "DetailButtonTableViewCell", bundle: nil)
		tableView.register(buttonCellnib, forCellReuseIdentifier: "detailButtonCell")
		
		let locationCellnib = UINib(nibName: "AddressTableViewCell", bundle: nil)
		tableView.register(locationCellnib, forCellReuseIdentifier: "AddressCell")
		
		let participantNib = UINib(nibName: "ParticipantsTableViewCell", bundle: nil)
		tableView.register(participantNib, forCellReuseIdentifier: "participantsCell")
	}
	
	func setupNavigationController() {
		
		let chatIcon = UIBarButtonItem(image: UIImage(named: "chatIcon"), style: .plain, target: self, action: #selector(chatButtonPressed))
		let shareButton = UIBarButtonItem.menuButton(self, action: #selector(showActionSheet), imageName: "moreIcon")
		var items: [UIBarButtonItem]!
		
		if (viewModel.currentType == 1 && (viewModel.isParticipating || viewModel.isUserCreator)) ||
			(viewModel.currentType == 2 && (viewModel.isParticipating || viewModel.isUserCreator)) {
			items = [shareButton, chatIcon]
		} else {
			items = [shareButton]
		}
		self.navigationItem.setRightBarButtonItems(items, animated: true)
	}

	@objc func chatButtonPressed() {
		
		let user = User(id: Auth.auth().currentUser!.uid, userName: (Auth.auth().currentUser?.displayName)!, userEmail: (Auth.auth().currentUser?.email)!)
		let str = viewModel.chatId
		channelReference.document(str).getDocument { (querySnapshot, error) in
			guard let snapshot = querySnapshot else {
			  print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
			  return
			}
			guard let channel = Chat(documentt: snapshot) else {
			  return
			}
			self.coordinator?.goToChat(with: user, chanel: channel, from: self)			
		}
	}
	
	func createCells() {

		let nameCell = DetailCellDefinition(title: "Name", awatar: UIImage(), content: viewModel.name, backgroundColor: .darkGray, type: .text, identifier: "DetailCell", target: self)
		
		let venueNameCell = DetailCellDefinition(title: "Venue Name", awatar: UIImage(named: "venueIcon")!, content: viewModel.venueName, backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell", target: self)
		
		let organizerNameCell = DetailCellDefinition(title: "Organizer Name", awatar: UIImage(named: "nameIcon")!, content: viewModel.managerName, backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell", target: self)
		
		let locationCell = DetailCellDefinition(title: "Address", awatar: UIImage(named: "addressIcon")!, content: viewModel.address, backgroundColor: .darkGray, type: .text, action: nil, identifier: "AddressCell", target: self)
		
		let timeCell = DetailCellDefinition(title: "Time", awatar: UIImage(named: "timeIcon")!, content: viewModel.timeString, backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell", target: self)
		
		let dateCell = DetailCellDefinition(title: "Date", awatar: UIImage(named: "dateIcon")!, content: viewModel.dateString, backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell", target: self)
		
		let contactNumberCell = DetailCellDefinition(title: "Contact Number", awatar: UIImage(named: "numberIcon")!, content: viewModel.managerNumber, backgroundColor: .darkGray, type: .text, identifier: "DetailCell", target: self)
		
		let participantsCell = DetailCellDefinition(title: "Participants", awatar: UIImage(named: "usersIcon")!, content: String(describing: viewModel.numberOfUsersParticipating), backgroundColor: .darkGray, type: .text, action: #selector(showParticipants), identifier: "participantsCell", target: self)
		
		
		let typeCell = DetailCellDefinition(title: "Type", awatar: ScrimmageType(rawValue: viewModel.currentType)!.icon, content: ScrimmageType(rawValue: viewModel.currentType)!.description, backgroundColor: .darkGray, type: .text, identifier: "DetailCell", target: self)
		
		
		let statusCell = DetailCellDefinition(title: "Status", awatar: ScrimmageStatus(rawValue: viewModel.currentStatus)!.icon, content: ScrimmageStatus(rawValue: viewModel.currentStatus)!.description, backgroundColor: .darkGray, type: .text, identifier: "DetailCell", target: self)
		
		let priceCell = DetailCellDefinition(title: "Price", awatar: UIImage(named: "priceIcon")!, content: String(format: "%.2f", viewModel.price), backgroundColor: .darkGray, type: .text, identifier: "DetailCell", target: self)
		
		let participateCell = DetailCellDefinition(title: "Participate", awatar: UIImage(), content: "", backgroundColor: .darkGray, type: .text, action: #selector(participateButtonPressed), identifier: "detailButtonCell", target: self)
		
		let savebuttonCell = DetailCellDefinition(title: "Save", awatar: UIImage(), content: "", backgroundColor: .darkGray, type: .text, action: #selector(saveScrimmageOnRemote(sender:)), identifier: "detailButtonCell", target: self)
		
		let notesCell =  DetailCellDefinition(title: "Notes", awatar: UIImage(named: "notes")!, content: viewModel.notes, backgroundColor: .darkGray, type: .text, identifier: "DetailCell", target: self)
		
	cellsArray = [nameCell, venueNameCell, organizerNameCell, timeCell, dateCell, contactNumberCell, participantsCell, typeCell, statusCell, priceCell, locationCell, notesCell, participateCell, savebuttonCell]
		
	}

	@objc func saveScrimmageOnRemote(sender: AnyObject) {
	
		guard let currentScrimmageId = self.viewModel?.id else { return }
        FIRFirestoreService.shared.updateSavedTable(for: currentScrimmageId, with: self.userID) { (success) in
            if success {
				AlertController.showAllert(self, title: "Saved", message: "This Scrimmage is added to your saved")
            } else {
				AlertController.showAllert(self, title: "Sorry", message: "There was a problem saving you scrimmage.")
            }
        }
    }
	
	@objc func showParticipants(sender: UIButton!) {
		self.coordinator?.goToViewUsers(with: viewModel!.participants, from: self)
	}
				
	@objc func participateButtonPressed(sender: UIButton!) {
        
		guard let currentScrimmageId = self.viewModel?.id else { return }
		if viewModel.isParticipating && viewModel.participantStatus == .confirmed {
			FIRFirestoreService.shared.updateParticipantsTable(for: currentScrimmageId, for: self.userID, with: 2) { (succesful) in
				AlertController.showAllert(self, title: "You are not going", message: "You are not going to this scrimmage.")
			}
		} else if viewModel.isParticipating && viewModel.participantStatus == .unconfirmed {
			FIRFirestoreService.shared.updateParticipantsTable(for: currentScrimmageId, for: self.userID, with: 1) { (succesful) in
				AlertController.showAllert(self, title: "You are going", message: "You are going to this scrimmage.")
			}
		} else if !viewModel.isParticipating {
            FIRFirestoreService.shared.addToParticipantsTable(for: currentScrimmageId, with: self.userID, status: 2) { (succesful) in
                if succesful {
					AlertController.showAllert(self, title: "Added", message: "You are participating in this scrimmage.")
                } else {
					AlertController.showAllert(self, title: "Sorry", message: "Couldn't add you as participant.")
                }
            }
        }
    }
	
	func leaveTheGroup() {
		if viewModel.isParticipating {
			let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to leave?", preferredStyle: .alert)
			let noAction  = UIAlertAction(title: "No", style: .default, handler: nil)
			let yesAction  = UIAlertAction(title: "Yes", style: .destructive) { (_) in
				guard let currentScrimmageId = self.viewModel?.id else { return }
				FIRFirestoreService.shared.removeFromParticipantsTable(for: currentScrimmageId, with: self.userID, status: .confirmed, participants: self.viewModel.participants) { (success) in
					if success {
						AlertController.showAllert(self, title: "Removed", message: "You are removed from Scrimmage.")
					} else {
						AlertController.showAllert(self, title: "Sorry", message: "There was a problem removing you from participants.")
					}
				}
			}
			alert.addAction(noAction)
			alert.addAction(yesAction)
			self.present(alert, animated: true)
		}
	}
	
	func observeScrimmage() {
		guard let scrimmageId = viewModel.id else {return}
        FIRFirestoreService.shared.readOne(from: .scrimmages, with: scrimmageId, returning: Scrimmage.self) { (scrimmage) in
            self.viewModel = ScrimmageViewModel(scrimmage: scrimmage)
			self.createCells()
			self.setupNavigationController()
			self.tableView.reloadData()
        }
    }
	
	func shareButtonPressed() {
        let shareItem = "Hey Im going to \(viewModel.name), do you want to join me?"
        let activityController = UIActivityViewController(activityItems: [shareItem], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = self.view
        present(activityController, animated: true, completion: nil)
    }
	
	@objc func showActionSheet() {
		let alert = UIAlertController(title: "", message: "Please select", preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Share with ...", style: .default, handler: {(_) in
			self.shareButtonPressed()
		}))
		if viewModel.isParticipating {
			alert.addAction(UIAlertAction(title: "Leave Scrimmage", style: .destructive, handler: {(_) in
				self.leaveTheGroup()
			}))
		}
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {(_) in
			print("User click Dismiss button")
		}))
		self.present(alert, animated: true, completion: {
			print("completion block")
		})
	}
	
	func mapTapped() {
		let alert = UIAlertController(title: "", message: "Please select", preferredStyle: .actionSheet)
		
		alert.addAction(UIAlertAction(title: "Open in Maps", style: .default, handler: {(_) in
			let destination = MKMapItem(coordinate: .init(latitude: self.viewModel.geopoint.latitude, longitude: self.viewModel.geopoint.longitude), name: self.viewModel.name)
			MKMapItem.openMaps(with: [destination], launchOptions: nil)
		}))
		if viewModel.isParticipating {
			alert.addAction(UIAlertAction(title: "Open in Google Maps", style: .default, handler: {(_) in
				self.openGoogleMap()
		}))
		}
		alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: {(_) in
			print("User click Dismiss button")
		}))
		self.present(alert, animated: true, completion: {
			print("completion block")
		})
	}
	
	func openGoogleMap() {
		
		if (UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)) {  //if phone has an app
			
			if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(viewModel.geopoint.latitude),\(viewModel.geopoint.longitude)") {
				UIApplication.shared.open(url, options: [:])}
		}
		else {
			//Open in browser
			if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(viewModel.geopoint.latitude),\(viewModel.geopoint.longitude)") {
				UIApplication.shared.open(urlDestination)
			}
		}
	}
}

extension UIBarButtonItem {

    static func menuButton(_ target: Any?, action: Selector, imageName: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true

        return menuBarItem
    }
}

extension MKMapItem {
  convenience init(coordinate: CLLocationCoordinate2D, name: String) {
    self.init(placemark: .init(coordinate: coordinate))
    self.name = name
  }
}
