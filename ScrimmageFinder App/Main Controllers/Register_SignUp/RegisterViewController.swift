//
//  RegisterViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartek Popcorn on 18/07/2018.
//  Copyright © 2018 The App Experts. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, Storyboarded, UITextFieldDelegate {

    @IBOutlet var userNameTF: UITextField!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passTF: UITextField!
    @IBOutlet weak var repeatPassTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }

    @IBAction func registeClick(_ sender: Any) {
        
        self.showSpinner(onView: self.view)
        guard let userName = userNameTF.text,
        !userName.trimmingCharacters(in: .whitespaces).isEmpty,
        let email = emailTF.text,
        !email.trimmingCharacters(in: .whitespaces).isEmpty,
        let password = passTF.text,
            !password.trimmingCharacters(in: .whitespaces).isEmpty, passTF.text == repeatPassTF.text
            else {
                self.removeSpinner()
                AlertController.showAllert(self, title: "Missing Info", message: "Please Insert All Data")
                return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            
            if error == nil && user != nil {
                self.removeSpinner()
                AlertController.showAllert(self, title: "Awesome", message: "You have created your account")
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = userName
                changeRequest?.commitChanges { error in
                    if error == nil {
                        print("User Display name Chnaged")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
             if let err = error {
                self.removeSpinner()
                print(err.localizedDescription)
                AlertController.showAllert(self, title: "Sorry!", message: "Couldn't create user, please try again")
                return
            }
        })
    }
    
    @IBAction func alreadyHaveAccountButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        self.title = "Register"
        self.passTF.delegate = self
        self.emailTF.delegate = self
        self.userNameTF.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height * 0.3)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        passTF.resignFirstResponder()
        repeatPassTF.resignFirstResponder()
        return true
    }
}
