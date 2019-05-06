//
//  CoordinatedNavigationController.swift
//  ScrimmageFinder App
//
//  Created by Bartek Prazmo on 05/05/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import UIKit

/// A navigation controller that is aware of its coordinator. This is used extremely rarely through UIResponder-Coordinated.swift, for when we need to find the coordinator responsible for a specific view.
class CoordinatedNavigationController: UINavigationController {
    weak var coordinator: Coordinator?
}
