//
//  MasterViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 29/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class MasterViewController<T: BaseCell<U>, U>: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	var items = [U]()
	
	var tableView: UITableView! {
		didSet {
			registerNib()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? BaseCell<U> else {return BaseCell<Any>()}
		cell.item = items[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}
	
	func registerNib() {
		let nib = UINib(nibName: String(describing: T.self), bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: String(describing: T.self))
	}
	
	@objc func logOutClicked() {
        CoreDataController.shared.removeProfileImage()
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
        GIDSignIn.sharedInstance()?.signOut()
		LoginManager().logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
}

class BaseCell<U>: UITableViewCell {
	var item: U!
	var identifier: String!
}
