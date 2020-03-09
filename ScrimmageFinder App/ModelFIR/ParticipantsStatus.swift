//
//  ParticipantsStatus.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 21/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation

enum ParticipantsStatus: Int, Codable, CustomStringConvertible {
    case confirmed = 1, unconfirmed
        
    var description: String {
        switch self {
        case .confirmed: return "confirmed"
        case .unconfirmed: return "unconfirmed"
        }
    }
	
	var value: Int {
	switch self {
	case .confirmed: return 1
	case .unconfirmed: return 2
	}
}
}
