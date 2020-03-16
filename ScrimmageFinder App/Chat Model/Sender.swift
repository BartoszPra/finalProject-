//
//  SenderType.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 15/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
