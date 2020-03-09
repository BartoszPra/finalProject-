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
    
    init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController(), scrimmage: Scrimmage, isSavedUsed: Bool) {
        self.navigationController = navigationController
        navigationController.coordinator = self
        let viewController = SFdetailViewController(nibName: "SFdetailViewController", bundle: nil, scrimmage: scrimmage, isSaveUsed: isSavedUsed)
        viewController.coordinator = self
        viewController.title = "Details"
        navigationController.pushViewController(viewController, animated: true)
    }
        
    func start() {
        
    }
    
    func goToViewUsers(with participants: [[String: ParticipantsStatus]], from controller: UIViewController) {
        let viewController = UsersListViewController.init(nibName: "UsersListViewController", bundle: nil, participants: participants)
        controller.navigationController!.pushViewController(viewController, animated: true)
    }
    
}
