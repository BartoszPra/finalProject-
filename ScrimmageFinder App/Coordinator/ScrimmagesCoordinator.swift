//
//  ScrimmagesCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 05/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit
import Foundation

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
    
    func goToDetail(with scrimage: Scrimmage ){
        let vc = Detail1ViewController.instantiate()
        vc.scrimmagePassedOver = scrimage
        navigationController.pushViewController(vc, animated: false)
    }
    
    func goToAddScrimmage() {
        let vc = addScrimmageViewController.instantiate()
        navigationController.pushViewController(vc, animated: false)
    }
    
    func start() {
        
    }
}

