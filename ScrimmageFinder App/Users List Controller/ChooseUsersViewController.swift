//
//  ChooseUsersViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 17/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase

enum UsersListPurpose {
	case chat
	case scrimmage
}

protocol AddUsersDelegate: class {
	func passUsers(users: [User], title: String)
}

class ChooseUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var groupNameTextField: UITextField!
	@IBOutlet weak var logoImageView: UIImageView!
	@IBOutlet weak var chatNameAndIconView: UIView!
	weak var delegate: AddUsersDelegate?
	var usersAdded = [User]()
	var chatTitle = ""
	var createButton: UIBarButtonItem!
	var users = [User]()
	var currentUserId: String!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Add participants"
		currentUserId = Auth.auth().currentUser!.uid
		self.chatNameAndIconView.isHidden = true
		let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "chetsCell")
		createButton = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(createTapped))
		navigationItem.rightBarButtonItem = createButton
		createButton.isEnabled = false
		self.tableView.delegate = self
		self.tableView.dataSource = self
		getUsers()
		self.groupNameTextField.attributedPlaceholder = NSAttributedString(string: "Insert chat name", attributes: [.foregroundColor: UIColor.darkGray])
		self.groupNameTextField.textColor = .white
		
    }
	
	func getUsers() {
		FIRFirestoreService.shared.readAll(from: .users, returning: User.self) { (users) in
			
			self.users = users.filter({ (user) -> Bool in
				user.id != self.currentUserId
			})
			self.tableView.reloadData()
		}
	}
	
	func isCreateEnabled() -> Bool {
		if !usersAdded.isEmpty {
			return true
		} else {
			return false
		}
	}
	
	@objc func createTapped() {
		print("chat creaed")
		if usersAdded.count > 1 && self.groupNameTextField.text!.isEmpty {
			AlertController.showAllert(self, title: "Oops", message: "Please insert chat name")
		} else if usersAdded.count > 1 && !self.groupNameTextField.text!.isEmpty {
			chatTitle = groupNameTextField.text!
		}
		self.delegate?.passUsers(users: self.usersAdded, title: self.chatTitle)
		self.navigationController?.popViewController(animated: true)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 45
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return users.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "chetsCell", for: indexPath) as? ChatTableViewCell else {return ChatTableViewCell()}
		cell.configureWithCheckBox(isEnabled: true)
		let user = users[indexPath.row]
		cell.name.text = user.userName
		cell.subName.text = "Active"
		cell.chatImage.loadUserImageUsingCashe(userId: user.id!)
        return cell
	}
		
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		manageGroupView()
		let cell = self.tableView.cellForRow(at: indexPath) as? ChatTableViewCell
		cell?.checkImage.backgroundColor = .blue
		let user = users[indexPath.row]
		usersAdded.append(user)
		self.createButton.isEnabled = isCreateEnabled()
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		let user = users[indexPath.row]
		let cell = self.tableView.cellForRow(at: indexPath) as? ChatTableViewCell
		cell?.checkImage.backgroundColor = .clear
		if let index = usersAdded.index(of: user) {
			usersAdded.remove(at: index)
		}
		manageGroupView()
		self.createButton.isEnabled = isCreateEnabled()
	}
	
	func manageGroupView() {
		if let selectedRows  = self.tableView.indexPathsForSelectedRows {
			if selectedRows.count > 1 {
				UIView.animate(withDuration: 0.3) {
					self.chatNameAndIconView.isHidden = false
				}
			} else {
				UIView.animate(withDuration: 0.3) {
					self.chatNameAndIconView.isHidden = true
				}
			}
		}
	}
}
