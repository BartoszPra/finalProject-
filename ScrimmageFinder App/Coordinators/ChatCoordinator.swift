//
//  ChatCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 09/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class ChatCoordinator: Coordinator {
    
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        let viewController = ChatsTableViewController(nibName: "ChatsTableViewController", bundle: nil) as ChatsTableViewController
        viewController.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(named: "tabBarImage"), tag: 0)
        viewController.coordinator = self
        navigationController.viewControllers = [viewController]
    }
    
    func start() {
    }
    
    func goToChat(with id: String, from controller: UIViewController) {
		
    }
}
