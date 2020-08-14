//
//  AddScrimmageCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 01/07/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class AddScrimmageCoordinator: Coordinator {
    
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
		let viewController = NewScrimmageTableViewController(nibName: "NewScrimmageTableViewController", bundle: nil, isEdit: false, scrimmageId: nil)
		viewController.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tabBarLogo"), tag: 0)
        navigationController.pushViewController(viewController, animated: true)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func start() {
    }
    
    func goToChat(with id: String, from controller: UIViewController) {
		
    }
}
