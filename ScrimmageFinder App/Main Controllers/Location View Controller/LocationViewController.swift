//
//  LocationViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 02/07/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
		
	@IBOutlet weak var tableView: UITableView!
	
	private var selectedIndexPath: IndexPath?
	private var sugestedRadius = 80
	private var customRadius =  80
	private var city = ""
			
	override func viewDidLoad() {
        super.viewDidLoad()
		self.registerNib()
		self.tableView.delegate = self
		self.tableView.dataSource = self
		
    }
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 2
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "sliderCell",
		for: indexPath) as? SliderTableViewCell else { return SliderTableViewCell() }
		
		let isSelectedCell = indexPath == self.selectedIndexPath
		
		cell.configureCell(isCellSelected: isSelectedCell, radius: sugestedRadius, indexPath: indexPath)
		return cell
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.selectedIndexPath = indexPath
		self.tableView.reloadData()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		switch indexPath.row {
		case 0:
			return 80
		case 1:
			return 110
		default:
			return 110
		}
	}
	
	func registerNib() {
		let nib = UINib(nibName: "SliderTableViewCell", bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: "sliderCell")
	}
}
