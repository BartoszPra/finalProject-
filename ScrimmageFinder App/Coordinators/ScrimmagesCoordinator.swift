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
		
		//let viewController = SomeController()
		let viewController = ScrimmagesListViewController.init(nibName: "ScrimmagesListViewController", bundle: nil)
		
		//let viewController = ScrimmageListViewController.init(nibName: "ScrimmageListViewController", bundle: nil)
		
		//let viewController = ScrimmagesViewController.instantiate()
        viewController.tabBarItem = UITabBarItem(title: "Scrimmages", image: UIImage(named: "ScrIcon"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
	func goToNewDetail(with scrimmage: ScrimmageViewModel, from controller: UIViewController, image: UIImage) {
        ScrimmagesDetailCoordinator(navigationController: navigationController, scrimmage: scrimmage, isSavedUsed: true, image: image)
    }
        
    func goToAddScrimmage() {
		let viewController = NewScrimmageTableViewController(isEdit: false)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func start() {
    }
}
