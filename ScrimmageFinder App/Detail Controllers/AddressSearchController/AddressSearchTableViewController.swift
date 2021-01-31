//
//  AddressControllerTableViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 30/01/2021.
//  Copyright © 2021 The App Experts. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressSearchTableViewController: UITableViewController, UISearchBarDelegate {
        
	@IBOutlet weak var searchBar: UISearchBar!
	var searchItems = [MKMapItem]()
		
	override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		searchBar.delegate = self
    }
	
	//searchbarFunctions
	var searchActive: Bool = false

	private func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
		searchActive = true
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		searchActive = false
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchActive = false
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchActive = false
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		
		if searchText.count > 2 {
			let searchRequest = MKLocalSearch.Request()
			searchRequest.naturalLanguageQuery = searchText
			let search = MKLocalSearch(request: searchRequest)

			search.start { response, error in
				guard let response = response else {
					print("Error: \(error?.localizedDescription ?? "Unknown error").")
					return
				}

				for item in response.mapItems {
					self.searchItems.append(item)
				}

				self.tableView.reloadData()
			}

		} else {
			self.clearSearchTable()
		}
	}
	
	func clearSearchTable() {
		self.searchItems.removeAll()
		self.tableView.reloadData()
	}

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedLoc = searchItems[indexPath.row]
		let address = selectedLoc.placemark.thoroughfare?.description
		self.clearSearchTable()
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return searchItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = searchItems[indexPath.row].name
        // Configure the cell...

        return cell
    }
}
