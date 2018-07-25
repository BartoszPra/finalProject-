//
//  RegisterViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartek Popcorn on 18/07/2018.
//  Copyright © 2018 The App Experts. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet var userNameTF: UITextField!
    
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet var passTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func registeClick(_ sender: Any) {
        
        guard let userName = userNameTF.text,
        !userName.trimmingCharacters(in: .whitespaces).isEmpty,
        let email = emailTF.text,
        !email.trimmingCharacters(in: .whitespaces).isEmpty,
        let password = passTF.text,
        !password.trimmingCharacters(in: .whitespaces).isEmpty
            else{
                AlertController.showAllert(self, title: "Missing Info", message: "Please Insert All Data")
                return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion:{ (user, error) in
            if error == nil && user != nil {
                AlertController.showAllert(self, title: "Awesome", message: "You have created your account")
                let changeRequest  = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User Display name Chnaged")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
            }
            
            guard error  == nil else {
                AlertController.showAllert(self, title: "Error", message: error!.localizedDescription)
                return
                
                
            }
            
            
           
            
        })
    }
    

}
