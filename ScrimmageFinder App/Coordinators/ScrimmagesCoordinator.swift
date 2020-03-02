//
//  ScrimmagesCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 07/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class ScrimmagesCoordinator: Coordinator {
  
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        let viewController = ScrimmagesViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: " Scrimmages ", image: UIImage(named: "tabBarImage"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func goToNewDetail(with scrimmage: Scrimmage, from controller: UIViewController) {
        ScrimmagesDetailCoordinator(navigationController: navigationController, scrimmage: scrimmage, isSavedUsed: true)
    }
        
    func goToAddScrimmage() {
        let viewController = CreateScrimmageViewController.init(nibName: "CreateScrimmageViewController", bundle: nil)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func start() {
    }
}
