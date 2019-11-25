//
//  User.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 23/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String?
    var userName: String
    var userEmail: String
    
    init(userName: String, userEmail: String) {
        self.userName = userName
        self.userEmail = userEmail
    }    
}
