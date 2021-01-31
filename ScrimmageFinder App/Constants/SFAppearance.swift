//
//  SFAppearance.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 17/10/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class SFAppearance {
    
    static func setUpApperance() {
        self.setupNavigationBar()
        self.setutNavigationBarAppearance()
        setupSearchBarAppearance()
    }
    
    static func setupNavigationBar() {
        let tabBarAppearance = UITabBar.appearance()
		tabBarAppearance.tintColor = SFTheme.SFColors().tintBlueColor
        tabBarAppearance.barTintColor = UIColor.black
        tabBarAppearance.unselectedItemTintColor = UIColor.white
        
    }
    
    static func setutNavigationBarAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = UIColor.black
        navigationBarAppearace.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    static func setupSearchBarAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
