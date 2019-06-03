//
//  SavedScrimmageCoordiantor.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class SavedScrimmagesCoordinator: Coordinator {
    
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        let viewController = SavedScrimmagesViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: "Scrimmages", image: UIImage(named: "tabBarImage"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    func goToDetail(with scrimmage: ScrimmageSaved) {
        let viewController = SavedDetailViewController.instantiate()
        viewController.scrimmagePassedOver2 = scrimmage
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func start() {
    }
}
