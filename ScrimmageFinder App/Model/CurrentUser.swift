//
//  CurrentUser.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 15/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import Firebase


class CurrentUser {
	// still need fixing the force unwrap
	static let shared = CurrentUser()
	
	lazy var id = {return Auth.auth().currentUser!.uid}()
	lazy var userName = { return Auth.auth().currentUser!.displayName ?? "noNameFound"}()
	lazy var userEmail = {Auth.auth().currentUser!.email ?? "noEmailFound"}()
    
}
