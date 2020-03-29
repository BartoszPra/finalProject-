//
//  UsersListViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 23/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit
import SilentScrolly
import MobileCoreServices
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class UsersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var participantsIds = [[String: ParticipantsStatus]]()
    var participants = [User]()
    @IBOutlet weak var tableView: UITableView!
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, participants: [[String: ParticipantsStatus]]) {
        self.participantsIds = participants
        super.init(nibName: nil, bundle: nil)
    }    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "SFUserTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "userCell")
        self.loadParticipants()
    }
    
    func loadParticipants() {
        for idDict in participantsIds {
            guard let parId = idDict.keys.first else {return}
            FIRFirestoreService.shared.readOne(from: .users, with: parId, returning: User.self) { (user) in
                self.participants.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return participants.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell",
                                                       for: indexPath) as? SFUserTableViewCell else { return SFUserTableViewCell() }
        let user: User = self.participants[indexPath.row]
        guard let userId = user.id else {return UITableViewCell()}
        let statusForId = participantsIds.first { (idDict) -> Bool in
            idDict.keys.first == userId
        }
        cell.userNameLabel.text = user.userName
        if statusForId?.values.first == .confirmed {
            cell.userStatusLabel.textColor = .green
        } else {
            cell.userStatusLabel.textColor = .red
        }
        cell.userStatusLabel.text = statusForId?.values.first?.description
		cell.userImage.loadUserImageUsingCashe(userId: userId)
        return cell
    }
}
