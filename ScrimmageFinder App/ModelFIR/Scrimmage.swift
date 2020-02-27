import Foundation
import FirebaseAuth
import Firebase
//protocol for when the function will need id to be performed like delete and update
protocol  Identifiable {
    var id: String? {get set}
}

//scrimmgage struct with properties
struct Scrimmage: Codable, Identifiable {
    
    var id: String? = nil
    var name: String
    var managerName: String
    var managerNumber: String
    var price: Double
    var date: String
    var createdById: String
    var savedById: [String]
    var currentStatus: Int
    var currentType: Int
    var participants: [[String: ParticipantsStatus]]
	var address: String
	var dateTime: Date
	var geopoint: GeoPoint
	var notes: String
	
	//new scrimmaage struct init
	init (name: String, address:String, dateTime: Date, date:String, managerName: String, managerNumber: String, price: Double, createdById: String, currentStatus: Int, currentType: Int, participants: [[String: ParticipantsStatus]], geopoint: GeoPoint, notes: String) {
        self.name = name
		self.address = address
		self.dateTime = dateTime
        self.managerName = managerName
        self.managerNumber = managerNumber
        self.price = price
        self.createdById = Auth.auth().currentUser!.uid
        self.savedById = [String]()
        self.currentStatus = currentStatus
        self.currentType = currentType
        self.participants = participants
		self.geopoint = geopoint
		self.date = date
		self.notes = notes
    }
	
	func getTime() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"//"EE" to get short style
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
	
	func getDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"//"EE" to get short style
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
}
