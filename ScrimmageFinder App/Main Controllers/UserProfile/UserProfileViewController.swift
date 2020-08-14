//
//  UserProfileViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 24/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit
import Firebase

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
	var coordinator: UserProfileCoordinator!
    var imagePicker = UIImagePickerController()
    var profileImage: UIImage!
    var userID: String!
    let coreDataController = CoreDataController.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = Auth.auth().currentUser?.email
		
		self.view.backgroundColor = .black
		let image = UIImage(named: "black")!.alpha(0.7)
		navigationController?.navigationBar.setBackgroundImage(image, for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		
        userID = Auth.auth().currentUser?.uid
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
		displayNameLabel.text = Auth.auth().currentUser?.displayName
    }
    
    override func viewDidAppear(_ animated: Bool) {
                
        coreDataController.loadImage(for: userID) { (images) in
            if images != nil {
                guard let photoData = images?.first?.imageData else {return}
                profileImage = UIImage(data: photoData)
                self.profileImageView.image = profileImage
            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.navigationController?.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
			
			FIRFirestoreService.shared.uploadImage(image: pickedImage, uploadType: .userProfile, for: "123", for: userID) { (success) in
                if success {
                    self.coreDataController.removeProfileImage()
                    self.coreDataController.prepareImageForSaving(image: pickedImage)
					print("photo uploaded succesfully")
                }
            }
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
			FIRFirestoreService.shared.uploadImage(image: pickedImage, uploadType: .userProfile, for: "123", for: userID) { (success) in
                if success {
                    self.coreDataController.prepareImageForSaving(image: pickedImage)
					print("photo uploaded succesfully")
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
