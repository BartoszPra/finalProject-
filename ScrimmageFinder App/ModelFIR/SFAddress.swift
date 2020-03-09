//
//  SFAddress.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 29/02/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation

struct SFAddress: Codable {
	
	var venueName: String
    var line1: String?
    var line2: String
    var postCode: String
}
