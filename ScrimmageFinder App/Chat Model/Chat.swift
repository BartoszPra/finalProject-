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
	var image: UIImage!
	let currentUserId = Auth.auth().currentUser!.uid
	
	init(name: String, users: [String], isGroup: Bool) {
		self.name = name
		self.isGroup = isGroup
		self.users = users
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
	
	func returnChatsImage(with userId: String, completion: @escaping (UIImage?) -> Void) {
		if !isGroup {
			let filtered = users.filter { (user) -> Bool in
				user != currentUserId
			}
			UIImageView().returnImageUsingCashe(userId: filtered.first!) { (img) in
				completion(img)
				//return img
			}
//			let image = UIImageView().returnImageUsingCashe(userId: filtered.first!)
//			return image

		} else {
			completion(UIImage(named: "basketBallLogo")!)
			//return UIImage(named: "basketBallLogo")!
		}
	}
}

extension Chat: DatabaseRepresentation {
  
  var representation: [String: Any] {
	var rep = ["name": name,
			   "isGroup": isGroup,
			   "users": users] as [String : Any]
    
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
