//
//  File.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 26/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import Firebase

 class ScrimmageViewModel: NSObject {
	
	var id: String?
    var name: String
	var venueName: String
    var managerName: String
    var managerNumber: String
    var price: Double
    var createdById: String
    var savedById: [String]
    var currentStatus: Int
    var currentType: Int
    var participants: [String: ParticipantsStatus]
	var address: String
	var dateTime: Date
	var geopoint: GeoPoint
	var notes: String
	var chatId: String
	var userID: String!
	var imageUrl: String!
	var occurance: Int
		
	init(scrimmage: Scrimmage) {		
		self.id = scrimmage.id
		self.name = scrimmage.name
		self.venueName = scrimmage.venueName
		self.managerName = scrimmage.managerName
		self.managerNumber = scrimmage.managerNumber
		self.price = scrimmage.price
		self.createdById = scrimmage.createdById
		self.savedById = scrimmage.savedById
		self.currentStatus = scrimmage.currentStatus
		self.currentType = scrimmage.currentType
		self.participants = scrimmage.participants
		self.address = scrimmage.address
		self.dateTime = scrimmage.dateTime
		self.geopoint = scrimmage.geopoint
		self.notes = scrimmage.notes
		self.userID = Auth.auth().currentUser?.uid
		self.chatId = scrimmage.chatId
		self.imageUrl = scrimmage.imageUrl
		self.occurance = scrimmage.occurance
				
	}
	
	func createScrimmage() -> Scrimmage {
		
		let scrimmage = Scrimmage(id: self.id!,
								  name: self.name,
								  venueName: self.venueName,
								  address: self.address,
								  dateTime: self.dateTime,
								  managerName: self.managerName,
								  managerNumber: self.managerNumber,
								  price: self.price,
								  createdById: self.createdById,
								  currentStatus: self.currentStatus,
								  currentType: self.currentType,
								  participants: self.participants,
								  geopoint: self.geopoint,
								  notes: self.notes,
								  chatId: self.chatId,
								  imageUrl: self.imageUrl,
								  occurance: self.occurance)
		
		return scrimmage
	}
	
	lazy var participantStatus: ParticipantsStatus? = {
		if participants.isEmpty {
			if let participant = participants.first(where: { $0.key == userID }) {
				return participant.value
            } else {
				return nil
            }
		} else {
			return nil
		}
	}()
		
	lazy var isParticipating: Bool = {
		if participants.isEmpty {
			if let _ = participants.first(where: { $0.key == userID }) {
				return true
            } else {
				return false
            }
		} else {
			return false
		}
	}()
		
	var numberOfUsersParticipating: Int {
		let usersGoing = self.participants.filter { $0.value == .confirmed }
		return usersGoing.count
	}
	
	var isUserCreator: Bool {
		if self.createdById == Auth.auth().currentUser?.uid {
			return true
		} else {
			return false
		}
	}
	
	var timeString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
	
	var dateString: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
	
	var isAlreadySaved: Bool {
		if !self.savedById.isEmpty {
            if let _ = self.savedById.first(where: {$0 == self.userID}) {
                return true
            } else {
                return false
            }
        }
        return false
	}
		
	func getImage(completion: @escaping (UIImage?) -> Void) {
		UIImageView().loadImageUsingCashe(urlString: imageUrl) { (img) in
			completion(img)
		}
	}
}
