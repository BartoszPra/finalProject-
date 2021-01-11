//
//  ScrimmageStatus.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 20/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

enum ScrimmageStatus: Int, Codable, CustomStringConvertible {
    case on = 1, off
    
    var statusImage: UIImage {
        switch self {
        case .on: return UIImage.init(named: "statusON")!
        case .off: return UIImage.init(named: "statusOFF")!
        }
    }
	
	var icon: UIImage {
		switch self {
		case .on: return UIImage(named: "onIcon")!
		case .off: return UIImage(named: "offIcon")!
		}
	}
    
    var description: String {
        switch self {
        case .on: return "on"
        case .off: return "off"
        }
    }
}
