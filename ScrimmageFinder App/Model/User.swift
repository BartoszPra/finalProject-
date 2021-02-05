//
//  User.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 23/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import Firebase
import MessageKit

class User: Codable, Identifiable, SenderType {
	
	var senderId: String
	var displayName: String	
    var id: String?
    var userName: String
    var userEmail: String
	var phoneNumber: String?
    
	init(id: String, userName: String, userEmail: String, phoneNumber: String?) {
		self.id = id
        self.userName = userName
        self.userEmail = userEmail
		self.senderId = id
		self.displayName = userName
		self.phoneNumber = phoneNumber
    }
}

extension User: Equatable {
	static func == (lhs: User, rhs: User) -> Bool {
		return lhs.id == rhs.id
	}
}
