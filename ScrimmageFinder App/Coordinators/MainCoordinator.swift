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
    
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = LoginViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
        
    }
    
    func goToRegister() {
        let viewController = RegisterViewController.instantiate()
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func startTabBarCoordinator(viewController: UIViewController) {
        let tabViewController = TabBarController.instantiate()
        viewController.present(tabViewController, animated: false, completion: nil)
    }
}
