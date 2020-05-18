//
//  ChooseUsersViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 17/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Foundation
import Firebase

enum UsersListPurpose {
	case chat
	case scrimmageInvite
}

protocol AddUsersDelegate: class {
	func passUsers(users: [User], title: String, image: UIImage, isGrouped: Bool)
}

class ChooseUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
	var imagePicker = UIImagePickerController()
	var purpose: UsersListPurpose!
	var buttonTitle: String!
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, usage: UsersListPurpose) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if purpose == .chat {
			self.title = "Add participants"
		} else {
			self.title = "Invite users"
		}
		currentUserId = Auth.auth().currentUser!.uid
		self.chatNameAndIconView.isHidden = true
		let nib = UINib(nibName: "ChatTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "chetsCell")
		if purpose == .chat {
			buttonTitle = "Create"
		} else {
			buttonTitle = "Invite"
		}
		createButton = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(createTapped))
		navigationItem.rightBarButtonItem = createButton
		createButton.isEnabled = false
		self.tableView.delegate = self
		self.tableView.dataSource = self
		getUsers()
		self.groupNameTextField.attributedPlaceholder = NSAttributedString(string: "Insert chat name", attributes: [.foregroundColor: UIColor.darkGray])
		self.groupNameTextField.textColor = .white
		logoImageView.layer.cornerRadius = logoImageView.bounds.width / 2
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChooseUsersViewController.tapGesture))
		logoImageView.addGestureRecognizer(tapGesture)
		logoImageView.isUserInteractionEnabled = true
    }
		
	@objc func tapGesture() {
		print("photo tapped")
		if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            print("Button capture")

            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		picker.dismiss(animated: true, completion: nil)
		guard let image = info[.originalImage] as? UIImage else {
			fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
		}
		self.logoImageView.image = image
		self.logoImageView.contentMode = .scaleAspectFill
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
		if usersAdded.count > 1 && self.groupNameTextField.text!.isEmpty && purpose == .chat {
			AlertController.showAllert(self, title: "Oops", message: "Please insert chat name")
		} else if usersAdded.count > 1 && !self.groupNameTextField.text!.isEmpty {
			chatTitle = groupNameTextField.text!
			self.delegate?.passUsers(users: self.usersAdded, title: self.chatTitle, image: logoImageView.image!, isGrouped: true)
			self.navigationController?.popViewController(animated: true)
		} else {
			self.delegate?.passUsers(users: self.usersAdded, title: self.chatTitle, image: logoImageView.image!, isGrouped: false)
			self.navigationController?.popViewController(animated: true)
		}
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
		cell?.checkImage.backgroundColor = UIColor(hex: "#007aff")
		cell?.checkImage.image = UIImage(named: "tickWhite")
		let user = users[indexPath.row]
		usersAdded.append(user)
		self.createButton.isEnabled = isCreateEnabled()
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		let user = users[indexPath.row]
		let cell = self.tableView.cellForRow(at: indexPath) as? ChatTableViewCell
		cell?.checkImage.image = nil
		cell?.checkImage.backgroundColor = .clear
		if let index = usersAdded.index(of: user) {
			usersAdded.remove(at: index)
		}
		manageGroupView()
		self.createButton.isEnabled = isCreateEnabled()
	}
	
	func manageGroupView() {
		if purpose == .chat {
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
		} else {
			self.chatNameAndIconView.isHidden = true
		}
	}
}
