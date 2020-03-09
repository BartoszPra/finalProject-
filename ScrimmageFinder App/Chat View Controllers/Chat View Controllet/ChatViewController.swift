//
//  ChatViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    var id: String
	
	override func viewDidLoad() {
        super.viewDidLoad()

    }
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, chatId: String) {
		self.id = chatId
		super.init(nibName: nil, bundle: nil)
	}
}
