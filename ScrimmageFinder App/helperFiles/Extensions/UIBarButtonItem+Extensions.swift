//
//  UIBarButtonItem+Extension.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 14/10/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import Foundation
import UIKit


extension UIBarButtonItem {
    convenience init(image: UIImage, title: String, target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
		button.titleLabel?.font = button.titleLabel?.font.withSize(12)

        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        self.init(customView: button)

		let currHeight = self.customView?.heightAnchor.constraint(equalToConstant: 20)
		currHeight?.isActive = true
    }
}
