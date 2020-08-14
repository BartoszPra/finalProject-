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
    var scrimmagesView = [ScrimmageViewModel]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.title = "Created"
		self.view.backgroundColor = .black
		let image = UIImage(named: "black")!.alpha(0.7)
		navigationController?.navigationBar.setBackgroundImage(image, for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
        let nib = UINib(nibName: "SavedScrimmagesCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "SavedScrimmagesCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        FIRFirestoreService.shared.readWhere(from: .scrimmages,
                                             whereFld: "createdById",
                                             equalsTo: userID,
                                             returning: Scrimmage.self) { (scrimmages) in
												self.scrimmagesView = scrimmages.map({return ScrimmageViewModel(scrimmage: $0)})
                                             self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scrimmagesView.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SavedScrimmagesCell",
                                                       for: indexPath) as? SavedScrimmagesCell else { return SavedScrimmagesCell() }
        if !self.scrimmagesView.isEmpty {
            self.emptyListLabel.isHidden = true
            let scrimmage = scrimmagesView[indexPath.row]
			cell.configureCell(scrimmage: scrimmage)
            return cell
        } else {
            self.emptyListLabel.isHidden = false
            cell.cellLBL.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let scrimmage = self.scrimmagesView[indexPath.row]
		let cell = tableView.cellForRow(at: indexPath) as? SavedScrimmagesCell
		self.coordinator?.goToDetail(with: scrimmage, from: self, image: cell!.cellImage.image!)
    }
    
}
