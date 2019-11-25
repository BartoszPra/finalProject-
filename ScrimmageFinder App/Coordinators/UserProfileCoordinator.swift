//
//  UserProfileCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 24/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class UserProfileCoordinator: Coordinator {
  
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        let viewController = UserProfileViewController(nibName: "UserProfileViewController", bundle: nil)
        viewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "tabBarImage"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func start() {
    }
}
