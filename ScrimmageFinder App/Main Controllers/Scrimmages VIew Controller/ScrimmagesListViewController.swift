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
import CoreLocation
import MapKit

class ScrimmagesListViewController: MasterViewController<ScrimmagesCell, ScrimmageViewModel>, SFLocationDelegate, LocationViewDelegate {
	
	@IBOutlet weak var newTable: UITableView!
	
	var locationButton: UIBarButtonItem!
	
	var coordinator: ScrimmagesCoordinator?
	var locationManager: SFLocationManager!
	var service = FIRFirestoreService.shared
		
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView = newTable
		createBarButtons()
		locationManager = SFLocationManager()
		locationManager.locDelegate = self
				
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
	
	@objc func goToLocationChange() {
        self.coordinator?.goToLocationChange(delegate: self)
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
	
	func createBarButtons() {
		
		locationButton = UIBarButtonItem(image: UIImage(named: "location"), style: .plain, target: self, action: #selector(goToLocationChange))
		navigationItem.rightBarButtonItem = locationButton
		
		let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logOutClicked))
		navigationItem.leftBarButtonItem = logoutButton
		
	}
	
	func locationUpdated(city: String) {
		self.locationButton = UIBarButtonItem(image: UIImage(named: "location")!, title: city, target: self, action: #selector(goToLocationChange))
		navigationItem.rightBarButtonItem = locationButton
	}
	
	func locationHasChanged(location: CLLocationCoordinate2D) {
		self.locationManager.geocodeLocation(location: location)
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

extension UIBarButtonItem {
    convenience init(image: UIImage, title: String, target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
		button.titleLabel?.font = button.titleLabel?.font.withSize(12)

        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        self.init(customView: button)

		let currHeight = self.customView?.heightAnchor.constraint(equalToConstant: 20)
		currHeight?.isActive = true
    }
}
