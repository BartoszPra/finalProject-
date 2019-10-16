//
//  LoginViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartek Popcorn on 18/07/2018.
//  Copyright © 2018 The App Experts. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, Storyboarded {
   
    weak var coordinator: MainCoordinator?
    
    @IBOutlet var emailTF: UITextField!
    
    @IBOutlet var passTF: UITextField!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var facebookLoginSignInButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        facebookLoginSignInButton.delegate = self
        facebookLoginSignInButton.readPermissions = ["email", "public_profile"]
    }
    
    override func viewDidAppear(_ animated: Bool) {
            if let user = Auth.auth().currentUser {
                print(String(describing: user.displayName))
            self.coordinator?.startTabBarCoordinator(viewController: self)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
    
        self.loginWithFcb()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
         print("Did log out of facebook")
    }
    
    func loginWithFcb() {
      let accesToken = FBSDKAccessToken.current()
      guard let stringAccesTok = accesToken?.tokenString else {return}
      let credential = FacebookAuthProvider.credential(withAccessToken: stringAccesTok)
      Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
            if let error = error {
                print("Error logging in", error)
            } else {
                print("username\(String(describing: user))")
                self.coordinator?.startTabBarCoordinator(viewController: self)
            }
        })
    }
    
    @IBAction func registerClicked(_ sender: Any) {
        coordinator?.goToRegister()
    }
    
    @IBAction func onLoginCLick(_ sender: Any) {

        guard let email = emailTF.text else {return}
        guard let password = passTF.text else {return}
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            AlertController.showAllert(self, title: "Oops", message: "Plese insert correct Email format")
        } else if password.trimmingCharacters(in: .whitespaces).isEmpty {
            AlertController.showAllert(self, title: "Oops", message: "Plese insert correct Password")
        } else {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if (error == nil) && (user != nil) {
               self.coordinator?.startTabBarCoordinator(viewController: self)
            } else {
                AlertController.showAllert(self, title: "Oops", message: String(describing: error?.localizedDescription))
                print("Error logging in: \(String(describing: error?.localizedDescription))")
            }
        }
        }
    }
}
