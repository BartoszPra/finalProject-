//
//  TabBarController.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 07/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, Storyboarded {
    
    let scrimmages = ScrimmagesCoordinator()
    let savedScrimmages = SavedScrimmagesCoordinator()
    let myScrimmages = MyScrimmagesCoordinator()
    let userProfile = UserProfileCoordinator()
    let chats = ChatCoordinator()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		viewControllers = [scrimmages.navigationController, savedScrimmages.navigationController, myScrimmages.navigationController, chats.navigationController, userProfile.navigationController]        
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		self.tabBar.itemPositioning = .fill
		self.tabBar.itemSpacing = UIScreen.main.bounds.width / 5
	}
}
