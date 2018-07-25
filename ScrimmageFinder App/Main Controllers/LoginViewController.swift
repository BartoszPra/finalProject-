//
//  LoginViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartek Popcorn on 18/07/2018.
//  Copyright © 2018 The App Experts. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet var passTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "loginSuccessful", sender: self)
        }
    }

    @IBAction func onLoginCLick(_ sender: Any) {
        
        guard let email = emailTF.text else {return}
        guard let password = passTF.text else {return}
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            AlertController.showAllert(self, title: "Oops", message: "Plese insert correct Email")
        }else if password.trimmingCharacters(in: .whitespaces).isEmpty {
            AlertController.showAllert(self, title: "Oops", message: "Plese insert correct Password")
        }else {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if (error == nil) && (user != nil) {
                self.performSegue(withIdentifier: "loginSuccessful", sender: self)
            } else {
                print("Error logging in: \(String(describing: error?.localizedDescription))")
            }
        }
        }
    }
    
   
}
