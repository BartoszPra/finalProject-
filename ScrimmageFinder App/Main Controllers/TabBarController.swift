//
//  TabBarController.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 11/04/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, Storyboarded {

    let scrimages = ScrimmagesCoordinator()
    let savedScrimmages = SavedScrimmagesCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [scrimages.navigationController, savedScrimmages.navigationController]
    }

}
