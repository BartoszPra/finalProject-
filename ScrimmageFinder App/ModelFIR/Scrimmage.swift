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
    //var venueName: String
    //var postCode: String
    //var time: Double
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
    
    //scrimmage struct init
//    init (name: String, vanueName: String, postCode: String, time: Double, managerName: String, managerNumber: String, price: Double, date: String, createdById: String, currentStatus: ScrimmageStatus, currentType: ScrimmageType, participants: [[String: ParticipantsStatus]]) {
//        self.name = name
//        self.venueName = vanueName
//        self.postCode = postCode
//        self.time = time
//        self.managerName = managerName
//        self.managerNumber = managerNumber
//        self.price = price
//        self.date = date
//        self.createdById = Auth.auth().currentUser!.uid
//        self.savedById = [String]()
//        self.currentStatus = currentStatus
//        self.currentType = currentType
//        self.participants = participants
//    }
	
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
}
