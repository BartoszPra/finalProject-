//
//  MainCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 06/04/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit
import Foundation

class MainCoordinator: Coordinator {
    
    var controller: UINavigationController
    var children = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.controller = navigationController
    }
    
    func start() {
        let viewController = LoginViewController.instantiate()
        viewController.coordinator = self
        controller.pushViewController(viewController, animated: false)
        
    }
    
    func goToRegister() {
        let viewController = RegisterViewController.instantiate()
        controller.pushViewController(viewController, animated: false)
    }
    
    func startTabBarCoordinator(viewController: UIViewController) {
        let viewController = TabBarController.instantiate()
        viewController.present(viewController, animated: false, completion: nil)
    }
}
