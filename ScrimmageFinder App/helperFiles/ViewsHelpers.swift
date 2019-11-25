//
//  ViewsHelpers.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 24/11/2019.
//  Copyright © 2019 The App Experts. All rights reserved.
//

import Foundation
import UIKit

class ViewHelpers {
    
    static func setLogoAsNavigationTitle(imageName: String, on viewController: UIViewController) {
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.frame = titleView.bounds
            titleView.addSubview(imageView)
        viewController.navigationItem.titleView = titleView
        
    }
    
}
