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

class ChatsTableViewController: UITableViewController {
	
	var coordinator: ChatCoordinator?
	var chats = [Chat]()
	var currentUserString = Auth.auth().currentUser?.displayName
	private var currentChannelAlertController: UIAlertController?
	private let db = Firestore.firestore()
	private var channelReference: CollectionReference {
		return db.collection("chats")
	}
	private var channelListener: ListenerRegistration?
	
	deinit {
	  channelListener?.remove()
	}
	
	//private var currentUser: User!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "chetsCell")
		tableView.delegate = self
		tableView.dataSource = self
		self.title = "Chats"
		
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
		let currentChat = chats[indexPath.row]
		cell.name.text = currentChat.returnChatsName(with: currentUserString!)
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let user = User(id: Auth.auth().currentUser!.uid, userName: (Auth.auth().currentUser?.displayName)!, userEmail: (Auth.auth().currentUser?.email)!)
		let chat = chats[indexPath.row]
		let vc = ChatViewController(user: user, channel: chat)
		navigationController?.pushViewController(vc, animated: true)
		//coordinator?.goToChat(with: id!, from: self)
	}
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
	//TODO
//	private func createChannel() {
//		guard let ac = currentChannelAlertController else {
//		  return
//		}
//
//		guard let channelName = ac.textFields?.first?.text else {
//		  return
//		}
//
//		let channel = Chat(name: channelName)
//		channelReference.addDocument(data: channel.representation) { error in
//		  if let e = error {
//			print("Error saving channel: \(e.localizedDescription)")
//		  }
//		}
//	  }
	  
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
