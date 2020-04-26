//
//  ParticipantsStatus.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 21/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

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
	
	var color: UIColor {
		switch self {
		case .confirmed: return UIColor.init(hex: "4DCB60") ?? .yellow
		case .unconfirmed: return .red
		}
	}
}
