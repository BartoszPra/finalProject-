//
//  MyScrimmagesViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 09/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//
import UIKit
import SilentScrolly
import MobileCoreServices
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class MyScrimmagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var coordinator: MyScrimmagesCoordinator?
    var scrimmages = [Scrimmage]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.title = "My Scrimmages"
        let nib = UINib(nibName: "MyScrimmagesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MyScrimmagesCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        FIRFirestoreService.shared.readWhere(from: .scrimmages,
                                             whereFld: "createdById",
                                             equalsTo: userID,
                                             returning: Scrimmage.self) { (scrimmages) in
                                             self.scrimmages = scrimmages
                                             self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scrimmages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyScrimmagesCell", for: indexPath) as? MyScrimmagesCell else { return MyScrimmagesCell() }
        if !self.scrimmages.isEmpty {
            let scrimmage = scrimmages[indexPath.row]
            cell.cellLBL.text = scrimmage.name
            cell.addressLbl.text = scrimmage.venueName
            cell.timeLbl.text = scrimmage.date
            cell.cellImage.image = UIImage.init(named: "imageJordan")
            return cell
        } else {
            cell.cellLBL.text = ""
            return cell
        }
    }
}
