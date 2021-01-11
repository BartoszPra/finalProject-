//
//  FIRStorageReference.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 29/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation

enum FIRStorageReference: String {
    case profile
        
    var description: String {
        switch self {
        case .profile: return "gs://ProfileImage"
        }
    }
}
