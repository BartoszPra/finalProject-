//
//  User.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 23/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import Firebase

class User: Codable, Identifiable {
    var id: String?
    var userName: String
    var userEmail: String
    
	init(id: String, userName: String, userEmail: String) {
		self.id = id
        self.userName = userName
        self.userEmail = userEmail
    }
}
extension User: Equatable {
	static func == (lhs: User, rhs: User) -> Bool {
		return lhs.id == rhs.id
	}
}
