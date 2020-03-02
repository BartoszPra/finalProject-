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
        let viewController = SavedScrimmagesViewController.init(nibName: "SavedScrimmagesViewController", bundle: nil)
        viewController.tabBarItem = UITabBarItem(title: "Saved Scrimmages", image: UIImage(named: "tabBarImage"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func goToNewDetail(with scrimmage: Scrimmage, from controller: UIViewController) {
		ScrimmagesDetailCoordinator(navigationController: navigationController, scrimmage: scrimmage, isSavedUsed: true)
    }
    
    func start() {
    }
}
