//
//  MyScrimmagesViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 09/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//
import UIKit
import SilentScrolly
import MobileCoreServices
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class MyScrimmagesViewController: UIViewController {
    
    var coordinator: MyScrimmagesCoordinator?
    var scrimmages = [Scrimmage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        FIRFirestoreService.shared.readWhere(from: .scrimmages,
                                             whereFld: "createdById",
                                             equalsTo: "juPk8cPh6bc27EdwmL87ThukiSJ2",
                                             returning: Scrimmage.self) { (scrimmages) in
            self.scrimmages = scrimmages
            print(self.scrimmages.count)
        }

    }

}
