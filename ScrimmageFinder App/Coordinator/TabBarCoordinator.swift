//
//  TabBarCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 06/04/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation

import UIKit

class TabBarCoordinator: Coordinator {
    
    var controller: UITabBarController
    var children =  [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.controller = navigationController
    }
    
    func start() {
        let viewController = LoginViewController.instantiate()
        vc.coordinator = self
        controller.pushViewController(viewController, animated: false)
        
    }
    
    func goToRegister() {
        let viewController = RegisterViewController.instantiate()
        controller.pushViewController(viewController, animated: false)
    }
    
    func goToScrimages() {
        let viewController = ScrimmagesViewController.instantiate()
        controller.pushViewController(viewController, animated: false)
    }
}
