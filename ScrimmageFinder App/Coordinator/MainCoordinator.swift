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
        let vc = LoginViewController.instantiate()
        vc.coordinator = self
        controller.pushViewController(vc, animated: false)
        
    }
    
    func goToRegister() {
        let vc = RegisterViewController.instantiate()
        controller.pushViewController(vc, animated: false)
    }
    
    func startTabBarCoordinator(viewController: UIViewController){
        let vc = TabBarController.instantiate()
        viewController.present(vc, animated: false, completion: nil)
    }
    
    
    
}
