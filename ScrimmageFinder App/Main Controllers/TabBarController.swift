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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [scrimmages.navigationController, savedScrimmages.navigationController, myScrimmages.navigationController]
        let tabBar = self.tabBar
        //tabBar.tintColor = UIColor.darkGray
        tabBar.barTintColor = UIColor.darkGray
        tabBar.unselectedItemTintColor = UIColor.darkGray
        
        guard let tabBarItem = self.tabBarItem else { return }
        tabBarItem.badgeColor = UIColor.white
        
    }
}
