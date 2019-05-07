//
//  SavedScrimmagesCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 05/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit
import Foundation

class SavedScrimmagesCoordinator: Coordinator {
    
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        
        let viewController = SavedScrimmagesViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: "Save Scrimmages", image: UIImage(named: "tabBarImage"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func goToDetail(with scrimmage: ScrimmageSaved){
        let vc = SavedDetailViewController.instantiate()
        vc.coordinator = self
        vc.scrimmagePassedOver2 = scrimmage
        navigationController.pushViewController(vc, animated: false)
    }
    
    func start() {
        
    }
}
