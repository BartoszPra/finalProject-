//
//  ScrimmagesViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 28/04/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class ScrimmagesListViewController: MasterViewController<ScrimmagesCell, ScrimmageViewModel> {
	
	@IBOutlet weak var newTable: UITableView!
	
	var coordinator: ScrimmagesCoordinator?
	
	var service = FIRFirestoreService.shared
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView = newTable
		createBarButtons()
		self.view.backgroundColor = .black
		let image = UIImage(named: "black")!.alpha(0.7)
		navigationController?.navigationBar.setBackgroundImage(image, for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		
		ViewHelpers.setLogoAsNavigationTitle(imageName: "logoNoBackgroundBrighter", on: self)
		service.readAll(from: .scrimmages, returning: Scrimmage.self) {[weak self] (scrimmages) in
			self?.items = scrimmages.map({return ScrimmageViewModel(scrimmage: $0)})
			self?.tableView.reloadData()
		}
	}
	
	deinit {
		service.removeListener()
		print("MainVC was deinit")
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let scrimmage = items[indexPath.row]
		let cell = newTable.cellForRow(at: indexPath) as? ScrimmagesCell
		coordinator?.goToNewDetail(with: scrimmage, from: self, image: cell?.cellImage.image ?? UIImage())
	}
	
	@objc func goToAddScrimmagesClicked() {
        self.coordinator?.goToAddScrimmage()
    }
	
	@objc func logOutClicked() {
        CoreDataController.shared.removeProfileImage()
        do {
            try Auth.auth().signOut()
        } catch let err {
            print(err)
        }
        GIDSignIn.sharedInstance()?.signOut()
        FBSDKLoginManager().logOut()
        self.dismiss(animated: true, completion: nil)
        
    }
	
	func createBarButtons() {
		
		let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goToAddScrimmagesClicked))
		navigationItem.rightBarButtonItem = addButton
		
		let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutClicked))
		navigationItem.leftBarButtonItem = logoutButton
		
	}
}

extension UIImage {
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
