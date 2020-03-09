//
//  Chat.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation


struct Chat {
	
	var id: String
	var name: String
	var messages = [Message]()
	var participants = [User]()
	
	init(id: String, name:String) {
		self.id = id
		self.name = name
	}
	
}
