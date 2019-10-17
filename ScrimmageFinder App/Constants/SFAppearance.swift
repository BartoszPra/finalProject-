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
    }
    
    static func setupNavigationBar() {
        
        let appearance = UITabBar.appearance()
        appearance.tintColor = UIColor.yellow
        appearance.barTintColor = UIColor.darkGray
        appearance.unselectedItemTintColor = UIColor.white        
    }
}
