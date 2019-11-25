//
//  UserProfileViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 24/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var coordinator: UserProfileCoordinator!
    @IBOutlet weak var profileImageView: UIImageView!
    var imagePicker = UIImagePickerController()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
           } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           profileImageView.contentMode = .scaleAspectFit
           profileImageView.image = pickedImage
        }
           dismiss(animated: true, completion: nil)
    }
}
