//
//  File.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 26/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import Firebase

struct ScrimmageViewModel {
	
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
	var isParticipating: Bool!
	var participantStatus: ParticipantsStatus?
	var userID: String!
	var imageUrl: String!
		
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
				
		if !scrimmage.participants.isEmpty {
		
			if let participant = scrimmage.participants.first(where: { $0.key == self.userID}) {
				self.participantStatus = participant.value
				self.isParticipating = true
            } else {
				self.participantStatus = nil
				self.isParticipating = false
            }
		} else {
			self.isParticipating = false
		}
	}
	
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
