//
//  ChatsTableViewController.swift
//  ScrimmageFinder App
//
//  Created by Bartosz Prazmo on 08/03/2020.
//  Copyright © 2020 The App Experts. All rights reserved.
//

import UIKit

class ChatsTableViewController: UITableViewController {
        
	var chats = [Chat]()
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.navigationController?.title = "Chats"
		createChats()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
		return chats.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "chetsCell", for: indexPath) as? ChatTableViewCell else {return ChatTableViewCell()}
		
		cell.name.text = "Irati Masa"
		//cell?.imageView?.image =
		cell.subName.text = ""

        return cell
    }
	
	func createChats() {
		let chat1 = Chat(id: "1", name: "Irati")
		let chat2 = Chat(id: "2", name: "Pete")
		let chat3 = Chat(id: "3", name: "Mark")
		
		chats = [chat1, chat2, chat3]
		
	}
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}
