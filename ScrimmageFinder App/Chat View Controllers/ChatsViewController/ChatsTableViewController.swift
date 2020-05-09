//
//  ChatsTableViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ChatsTableViewController: UITableViewController, AddUsersDelegate {
	
	var coordinator: ChatCoordinator?
	var chats = [Chat]()
	var currentUserString = Auth.auth().currentUser?.displayName
	var currentUserId = Auth.auth().currentUser?.uid
	private var currentChannelAlertController: UIAlertController?
	private let db = Firestore.firestore()
	private var channelReference: CollectionReference {
		return db.collection("chats")
	}
	private var channelListener: ListenerRegistration?
	
	deinit {
	  channelListener?.remove()
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
		let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "chetsCell")		
		tableView.delegate = self
		tableView.dataSource = self
		self.title = "Chats"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addTapped))
		
		let afterWhere = channelReference.whereField("users", arrayContains: Auth.auth().currentUser!.uid)
		
		channelListener = afterWhere.addSnapshotListener { querySnapshot, error in
		  guard let snapshot = querySnapshot else {
			print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
			return
		  }
		  snapshot.documentChanges.forEach { change in
			self.handleDocumentChange(change)
		  }
		}
    }
	
	@objc func addTapped() {		 
		let vc = ChooseUsersViewController(nibName: "ChooseUsersViewController", bundle: nil)
		vc.delegate = self
		navigationController?.pushViewController(vc, animated: true)
	}
	
	func passUsers(users: [User], title: String, image: UIImage, isGrouped: Bool) {
		var userss = [String]()
		var titlee = title
		if !isGrouped {
			titlee = currentUserString! + ", " + users.first!.userName
		}		
		userss.append(currentUserId!)
		for user in users {
			userss.append(user.id!)
		}
		if isGrouped {
			FIRFirestoreService.shared.uploadImage(image, folderName: "ChatsAvatars") { (url) in
				self.createChannel(chatName: titlee, users: userss, isGrouped: isGrouped, chatImageUrl: url?.absoluteString ?? "")
			}
		} else {
			self.createChannel(chatName: titlee, users: userss, isGrouped: isGrouped, chatImageUrl: "")
		}
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return chats.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "chetsCell", for: indexPath) as? ChatTableViewCell else {return ChatTableViewCell()}
		cell.configureWithCheckBox(isEnabled: false)
		var currentChat = chats[indexPath.row]
		cell.name.text = currentChat.returnChatsName(with: currentUserString!)
		currentChat.returnChatsImage(with: currentUserId!) { (img) in
			self.chats[indexPath.row].image = img
			cell.chatImage.image = img
		}
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let user = User(id: Auth.auth().currentUser!.uid, userName: (Auth.auth().currentUser?.displayName)!, userEmail: (Auth.auth().currentUser?.email)!)
		let cell = tableView.cellForRow(at: indexPath) as? ChatTableViewCell
		let currentChat = chats[indexPath.row]
		let vc = ChatViewController(user: user, channel: currentChat)
		vc.chatImage = cell?.chatImage.image
		navigationController?.pushViewController(vc, animated: true)
	}
	
	private func createChannel(chatName: String, users: [String], isGrouped: Bool, chatImageUrl: String) {
		
		let channel = Chat(name: chatName, users: users, isGroup: isGrouped, url: chatImageUrl)
		channelReference.addDocument(data: channel.representation) { error in
			if let e = error {
				print("Error saving channel: \(e.localizedDescription)")
			} else {
				self.tableView.reloadData()
			}
		}
	}
	  
	private func addChannelToTable(_ chat: Chat) {
		guard !chats.contains(chat) else {
			return
		}
		
		chats.append(chat)
		chats.sort()
		
		guard let index = chats.index(of: chat) else {
			return
		}
		tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}
	  
	private func updateChannelInTable(_ chat: Chat) {
		guard let index = chats.index(of: chat) else {
			return
		}
		
		chats[index] = chat
		tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}
	
	private func removeChannelFromTable(_ chat: Chat) {
		guard let index = chats.index(of: chat) else {
			return
		}
		
		chats.remove(at: index)
		tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
	}
	  
	  private func handleDocumentChange(_ change: DocumentChange) {
		guard let channel = Chat(document: change.document) else {
		  return
		}
		
		switch change.type {
		case .added:
		  addChannelToTable(channel)
		  
		case .modified:
		  updateChannelInTable(channel)
		  
		case .removed:
		  removeChannelFromTable(channel)
		}
	  }
}
