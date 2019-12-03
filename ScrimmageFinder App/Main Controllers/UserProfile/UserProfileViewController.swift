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

    var coordinator: UserProfileCoordinator!
    @IBOutlet weak var profileImageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var profileImage: UIImage!
    var userID: String!
    
    override func viewDidAppear(_ animated: Bool) {
        FIRFirestoreService.shared.getProfileImage(for: userID) { (image) in
            self.profileImageView.image = image
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userID = Auth.auth().currentUser?.uid
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profileImageView.isUserInteractionEnabled = true
        imagePicker.delegate = self
        profileImageView.addGestureRecognizer(tapGestureRecognizer)

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
            FIRFirestoreService.shared.uploadProfileImage(image: pickedImage, for: userID)
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.contentMode = .scaleAspectFit
            profileImageView.image = pickedImage
            FIRFirestoreService.shared.uploadProfileImage(image: pickedImage, for: userID)
            
        }
        dismiss(animated: true, completion: nil)
    }
}
