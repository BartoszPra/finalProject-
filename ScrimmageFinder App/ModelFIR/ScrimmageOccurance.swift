//
//  ScrimmageOccurance.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 20/06/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

enum ScrimmageOccurance: Int, Codable, CustomStringConvertible {
    case dayly = 1, weekely, monthly
        
    var description: String {
        switch self {
        case .dayly: return "daily"
        case .weekely: return "weekly"
		case .monthly: return "monthly"
        }
    }
}
