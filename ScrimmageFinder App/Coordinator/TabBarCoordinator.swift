//
//  TabBarCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 06/04/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation

import UIKit
import Foundation

class TabBarCoordinator: Coordinator {
    
    var controller: UITabBarController
    var children =  [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.controller = navigationController
    }
    
    func start() {
        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        controller.pushViewController(vc, animated: false)
        
    }
    
    func goToRegister() {
        let vc = RegisterViewController.instantiate()
        controller.pushViewController(vc, animated: false)
    }
    
    func goToScrimages() {
        let vc = ScrimmagesViewController.instantiate()
        controller.pushViewController(vc, animated: false)
    }
    
    
    
    
}
