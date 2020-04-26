//
//  SFDetailsViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 11/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase

class SFDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	
	var cellsArray = [DetailCellDefinition]()
	
	var coordinator: ScrimmagesDetailCoordinator?
	var scrimmagePassedOver: Scrimmage!
	var scrimmagePasswedOverId: String!
    private let coreDataController = CoreDataController.shared
    private var userID: String!
    private var isSaveUsed: Bool!
    private var isParticipating: Bool!
	private var participantStatus: ParticipantsStatus?
	var scrimmageImage = UIImage()
	
	init(nibName nibNameOrNil: String, bundle nibBundleOrNil: Bundle?, scrimmage: Scrimmage, isSaveUsed: Bool) {
        super.init(nibName: nibNameOrNil as String, bundle: nibBundleOrNil)
        self.isSaveUsed = isSaveUsed
		self.scrimmagePassedOver = scrimmage
    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		reloadScrimmage()
		self.userID = Auth.auth().currentUser?.uid
		self.tableView.delegate = self
        self.tableView.dataSource = self
		setupNavigationController()
		setupCells()
		createCells()
        UserDefaults.standard.register(defaults: [String: Any]())
    }
		
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return cellsArray.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cellsArray[indexPath.row].identifier,
													   for: indexPath) as? MainDetailTableViewCell else {return MainDetailTableViewCell()}
		
		cell.configureCell(title: cellsArray[indexPath.row].title, contentText: cellsArray[indexPath.row].content, icon: cellsArray[indexPath.row].awatar, target: self, action: cellsArray[indexPath.row].action, isCurrentUserParticipating: isParticipating, participantsStatus: self.participantStatus)		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 55
	}
	
	func setupCells() {
	let nib = UINib(nibName: "DetailTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "DetailCell")
	let buttonCellnib = UINib(nibName: "DetailButtonTableViewCell", bundle: nil)
	tableView.register(buttonCellnib, forCellReuseIdentifier: "buttonCell")
	
	let participantNib = UINib(nibName: "ParticipantsTableViewCell", bundle: nil)
		tableView.register(participantNib, forCellReuseIdentifier: "participantsCell")
		
	}
	
	func setupNavigationController() {
		if (scrimmagePassedOver.currentType == 1 && (isUserAlreadyParticipating() || isUserCreator())) ||
		   (scrimmagePassedOver.currentType == 2 && (isUserAlreadyParticipating() || isUserCreator())) {
			navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "chatIcon"), style: .plain, target: self, action: #selector(chatButtonPressed))
		}
	}

	@objc func chatButtonPressed() {
		print("chatttt!!")
	}
	
	func createCells() {

		let nameCell = DetailCellDefinition(title: "Name", awatar: scrimmageImage, content: scrimmagePassedOver.name, backgroundColor: .darkGray, type: .text, identifier: "DetailCell")
		let venueNameCell = DetailCellDefinition(title: "Venue Name", awatar: UIImage(named: "venueIcon")!, content: scrimmagePassedOver.venueName, backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell")
		let organizerNameCell = DetailCellDefinition(title: "Organizer Name", awatar: UIImage(named: "nameIcon")!, content: scrimmagePassedOver.managerName, backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell")
		let addressCell = DetailCellDefinition(title: "Address", awatar: UIImage(named: "addressIcon")!, content: scrimmagePassedOver.address, backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell")
		let timeCell = DetailCellDefinition(title: "Time", awatar: UIImage(named: "timeIcon")!, content: scrimmagePassedOver.getTime(), backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell")
		let dateCell = DetailCellDefinition(title: "Date", awatar: UIImage(named: "dateIcon")!, content: scrimmagePassedOver.getDate(), backgroundColor: .darkGray, type: .text, action: nil, identifier: "DetailCell")
		let contactNumberCell = DetailCellDefinition(title: "Contact Number", awatar: UIImage(named: "numberIcon")!, content: scrimmagePassedOver.managerNumber, backgroundColor: .darkGray, type: .text, identifier: "DetailCell")
		
		let participantsCell = DetailCellDefinition(title: "Participants", awatar: UIImage(named: "usersIcon")!, content: String(describing: scrimmagePassedOver.participants.count), backgroundColor: .darkGray, type: .text, action: #selector(showParticipants), identifier: "participantsCell")
		
		let typeCell = DetailCellDefinition(title: "Type", awatar: ScrimmageType(rawValue: scrimmagePassedOver.currentType)!.icon, content: ScrimmageType(rawValue: scrimmagePassedOver.currentType)!.description, backgroundColor: .darkGray, type: .text, identifier: "DetailCell")
		
		let statusCell = DetailCellDefinition(title: "Status", awatar: ScrimmageStatus(rawValue: scrimmagePassedOver.currentStatus)!.icon, content: ScrimmageStatus(rawValue: scrimmagePassedOver.currentStatus)!.description, backgroundColor: .darkGray, type: .text, identifier: "DetailCell")
		
		let priceCell = DetailCellDefinition(title: "Price", awatar: UIImage(named: "priceIcon")!, content: String(format: "%.2f", scrimmagePassedOver.price), backgroundColor: .darkGray, type: .text, identifier: "DetailCell")
		
		let participateCell = DetailCellDefinition(title: "Participate", awatar: UIImage(named: "priceIcon")!, content: "", backgroundColor: .darkGray, type: .text, action: #selector(participateButtonPressed), identifier: "buttonCell")
		
		let saveCell = DetailCellDefinition(title: "Save", awatar: UIImage(named: "priceIcon")!, content: "", backgroundColor: .darkGray, type: .text, action: #selector(saveScrimmageOnRemote), identifier: "buttonCell")
		
	cellsArray = [nameCell, venueNameCell, organizerNameCell, timeCell, dateCell, contactNumberCell, participantsCell, typeCell, statusCell, priceCell, addressCell, participateCell, saveCell]
		
	}
	
	@objc func saveScrimmageOnRemote() {
        guard let currentScrimmageId = self.scrimmagePassedOver?.id else { return }
        FIRFirestoreService.shared.updateSavedTable(for: currentScrimmageId, with: self.userID) { (success) in
            if success {
                
                let alert = UIAlertController(title: "Saved",
                                              message: "This Scrimmage is added to your saved",
                                              preferredStyle: UIAlertController.Style.alert)
                //add button to allert
                let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    //self.reloadScrimmage()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Sorry",
                                              message: "There was a problem saving you scrimmage.",
                                              preferredStyle: UIAlertController.Style.alert)
                //add button to allert
                let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    //self.reloadScrimmage()
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
	
	@objc func showParticipants(sender: UIButton!) {
		self.coordinator?.goToViewUsers(with: scrimmagePassedOver!.participants, from: self)		
	}
				
	@objc func participateButtonPressed() {
        guard let currentScrimmageId = self.scrimmagePassedOver?.id else { return }
        
        if !self.isUserAlreadyParticipating() {
            
            FIRFirestoreService.shared.addToParticipantsTable(for: currentScrimmageId, with: self.userID, status: 1) { (succesful) in
				self.reloadScrimmage()
                if succesful {
                    let alert = UIAlertController(title: "Added.",
                                                  message: "You are participating in this scrimmage.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Sorry",
                                                  message: "Couldn't add you as participant.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
                        
			FIRFirestoreService.shared.removeFromParticipantsTable(for: currentScrimmageId, with: self.userID, status: .confirmed) { (success) in
                if success {
					self.reloadScrimmage()
                    let alert = UIAlertController(title: "Removed",
                                                  message: "You are removed from participants.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
						
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Sorry",
                                                  message: "There was a problem removing you from participants.",
                                                  preferredStyle: UIAlertController.Style.alert)
                    //add button to allert
                    let action = UIAlertAction.init(title: "OK", style: .default) { (_) in
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
	
	func reloadScrimmage() {
		guard let scrimmageId = scrimmagePassedOver.id else {return}
        FIRFirestoreService.shared.readOne(from: .scrimmages, with: scrimmageId, returning: Scrimmage.self) { (scrimmage) in
            self.scrimmagePassedOver = scrimmage
			self.isUserAlreadyParticipating()
			self.createCells()
			self.tableView.reloadData()
        }
    }
	
	func isUserAlreadyParticipating() -> Bool {
        if !self.scrimmagePassedOver.participants.isEmpty {
            if let participant = self.scrimmagePassedOver.participants.first(where: { $0.keys.contains(self.userID)}) {
                self.participantStatus = participant.values.first
                self.isParticipating = true
                return true
            } else {
                self.participantStatus = nil
                self.isParticipating = false
                return false
            }
		} else {
			self.isParticipating = false
			return false
		}        
    }
	
	func isUserCreator() -> Bool {
		if self.scrimmagePassedOver.createdById == Auth.auth().currentUser?.uid {
			return true
		} else {
			return false
		}
	}
}
