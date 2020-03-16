//
//  Message.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
	
	var sender: SenderType
	let id: String?
	let content: String
	let sentDate: Date
	var downloadURL: URL?
	var image: UIImage? = nil

	var kind: MessageKind {
		return .text(content)
	}

	var messageId: String {
		return id ?? UUID().uuidString
	}

	init(user: User, content: String) {
		sender = Sender(senderId: user.id!, displayName: user.userName)
		self.content = content
		sentDate = Date()
		id = nil
	}

	init?(document: QueryDocumentSnapshot) {
		let data = document.data()

		guard let sentDate = data["created"] as? Timestamp else {
			return nil
		}
		guard let senderID = data["senderID"] as? String else {
			return nil
		}
		guard let senderName = data["senderName"] as? String else {
			return nil
		}

		id = document.documentID

		self.sentDate = sentDate.dateValue()
		sender = Sender(senderId: senderID, displayName: senderName)

		if let content = data["content"] as? String {
			self.content = content
			downloadURL = nil
		} else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
			downloadURL = url
			content = ""
		} else {
			return nil
		}
	}
}

extension Message: DatabaseRepresentation {

	var representation: [String: Any] {
		var rep: [String: Any] = [
			"created": sentDate,
			"senderID": sender.senderId,
			"senderName": sender.displayName
		]

		if let url = downloadURL {
			rep["url"] = url.absoluteString
		} else {
			rep["content"] = content
		}

		return rep
	}

}

extension Message: Comparable {

	static func == (lhs: Message, rhs: Message) -> Bool {
		return lhs.id == rhs.id
	}

	static func < (lhs: Message, rhs: Message) -> Bool {
		return lhs.sentDate < rhs.sentDate
	}
}
