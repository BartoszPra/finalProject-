//
//  Storyboarded.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 06/04/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    
    static func instantiate() -> Self
    
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
        
        let cntrlId = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: cntrlId) as? Self else {return Self()}
        return viewController
    }
    
}
