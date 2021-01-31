//
//  ParticipantsStatus.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 21/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

@objc enum ParticipantsStatus: Int, Codable, CustomStringConvertible {
	case confirmed = 1, unconfirmed, invited
	
	var description: String {
		switch self {
		case .confirmed: return "confirmed"
		case .unconfirmed: return "unconfirmed"
		case .invited: return "invited"
		}
	}
	
	var value: Int {
		switch self {
		case .confirmed: return 1
		case .unconfirmed: return 2
		case .invited: return 3
		}
	}
	
	var color: UIColor {
		switch self {
		case .confirmed: return UIColor.init(hex: "4DCB60") ?? .yellow
		case .unconfirmed: return .red
		case .invited: return .green
		}
	}
}