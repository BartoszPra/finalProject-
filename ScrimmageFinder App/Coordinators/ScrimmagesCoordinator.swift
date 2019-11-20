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
        viewController.tabBarItem = UITabBarItem(title: "Scrimmages", image: UIImage(named: "tabBarImage"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func goToNewDetail(with scrimmage: Scrimmage, from controller: UIViewController) {
        let viewController = SFdetailViewController.init(nibName: "SFdetailViewController", bundle: nil, scrimmage:scrimmage, isSaveUsed: true) as SFdetailViewController
        controller.present(viewController, animated: true, completion: nil)
    }
        
    func goToAddScrimmage() {
        let viewController = AddScrimmageViewController.instantiate()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func start() {
    }
}