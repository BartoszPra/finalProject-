//
//  Type.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 21/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation

enum ScrimmageType: Int, Codable, CustomStringConvertible {
    case open = 1, close
        
    var description: String {
        switch self {
        case .open: return "public"
        case .close: return "private"
        }
    }
}
