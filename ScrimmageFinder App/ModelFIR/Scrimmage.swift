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
	var venueName: String
    var managerName: String
    var managerNumber: String
    var price: Double
    var createdById: String
    var savedById: [String]
    var currentStatus: Int
    var currentType: Int
    var participants: [String: ParticipantsStatus]
	var address: String
	var dateTime: Date
	var geopoint: GeoPoint
	var notes: String
	var chatId: String
	var imageUrl: String
	
	//new scrimmaage struct init
	init (name: String, venueName: String, address: String, dateTime: Date, managerName: String, managerNumber: String, price: Double, createdById: String, currentStatus: Int, currentType: Int, participants: [String: ParticipantsStatus], geopoint: GeoPoint, notes: String, chatId: String, imageUrl: String) {
        self.name = name
		self.venueName = venueName
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
		self.notes = notes
		self.chatId = chatId
		self.imageUrl = imageUrl
    }
	
	func getTime() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm"
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
	
	func getDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "dd.MM.yyyy"
		let mydt = dateFormatter.string(from: dateTime).capitalized
		return "\(mydt)"
	}
	
	func image(completion: @escaping (UIImage?) -> Void) {
		UIImageView().loadImageUsingCashe(urlString: imageUrl) { (img) in
			completion(img)
		}
	}
}
