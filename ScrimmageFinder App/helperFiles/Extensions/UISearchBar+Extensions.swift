//
//  UISearchBar+Extensions.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 06/01/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
}
