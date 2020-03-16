//
//  Chat.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import Firebase

struct Chat {
	
	var id: String?
	var name: String
	var messages = [Message]()
	var users = [String]()
	var isGroup: Bool
	
	init(name: String, isGroup: Bool) {
		self.name = name
		self.isGroup = isGroup
	}
	
	init?(document: QueryDocumentSnapshot) {
		let data = document.data()
		
		guard let name = data["name"] as? String else {
			return nil
		}
		
		guard let isGroup = data["isGroup"] as? Bool else {
			return nil
		}
		
		guard let users = data["users"] as? [String] else {
			return nil
		}
		
		id = document.documentID
		self.name = name
		self.users = users
		self.isGroup = isGroup
	}
	
	func returnChatsName(with userName: String) -> String {
		if !self.isGroup {
			let components = self.name.components(separatedBy: ",").filter {!$0.contains(userName)}
			return components.first ?? self.name
		} else {
			return self.name
		}
	}
}

extension Chat: DatabaseRepresentation {
  
  var representation: [String: Any] {
    var rep = ["name": name]
    
    if let id = id {
      rep["id"] = id
    }
    
    return rep
  }
  
}

extension Chat: Comparable {
  
  static func == (lhs: Chat, rhs: Chat) -> Bool {
	return lhs.id == rhs.id
  }
  
  static func < (lhs: Chat, rhs: Chat) -> Bool {
	return lhs.name < rhs.name
  }

}
