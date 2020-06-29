//
//  ScrimmageDetailCoordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 23/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class ScrimmagesDetailCoordinator: Coordinator {
    
    var navigationController: CoordinatedNavigationController
    var children = [Coordinator]()
    
	init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController(), scrimmage: ScrimmageViewModel, isSavedUsed: Bool, image:UIImage) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        let viewController = SFDetailsViewController(nibName: "SFDetailsViewController", bundle: nil, scrimmage: scrimmage, isSavedUsed: isSavedUsed)
        viewController.coordinator = self
        viewController.title = "Details"
		viewController.scrimmageImage = image
        navigationController.pushViewController(viewController, animated: true)
    }
        
    func start() {
        
    }
    
    func goToViewUsers(with participants: [String: ParticipantsStatus], from controller: UIViewController) {
        let viewController = UsersListViewController.init(nibName: "UsersListViewController", bundle: nil, participants: participants)
        controller.navigationController!.pushViewController(viewController, animated: true)
    }
	
	func goToChat(with user: User, chanel: Chat, from controller: UIViewController) {
		let viewController = ChatViewController(user: user, channel: chanel)
		viewController.chatImage = UIImage(named: "basketBallLogo")
        controller.navigationController!.pushViewController(viewController, animated: true)
	}
	
	func goToEdit(with viewModel: ScrimmageViewModel, from controller: UIViewController) {
		let viewController = NewScrimmageTableViewController(isEdit: true, scrimmageId: viewModel.id)
		let navController = UINavigationController(rootViewController: viewController)
		controller.present(navController, animated: true, completion: nil)
	}
    
}
