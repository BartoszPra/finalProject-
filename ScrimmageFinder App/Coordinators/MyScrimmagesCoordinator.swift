//
//  MyScrimmagesCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 09/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class MyScrimmagesCoordinator: Coordinator {
    
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        let viewController = MyScrimmagesViewController(nibName: "MyScrimmagesViewController", bundle: nil) as MyScrimmagesViewController
        viewController.tabBarItem = UITabBarItem(title: "Created", image: UIImage(named: "createdHIcon"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func start() {
    }
    
	func goToDetail(with scrimmage: Scrimmage, from controller: UIViewController, image: UIImage) {
		ScrimmagesDetailCoordinator(navigationController: navigationController, scrimmage: scrimmage, isSavedUsed: true, image: image)
    }
}
