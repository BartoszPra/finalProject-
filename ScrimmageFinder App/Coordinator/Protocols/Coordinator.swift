//
//  Coordinator.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 06/04/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: CoordinatedNavigationController { get set }
    //var controller: UINavigationController {get set}
    var children: [Coordinator] {get set}
    func start()
    
}
